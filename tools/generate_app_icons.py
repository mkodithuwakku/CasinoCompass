#!/usr/bin/env python3
from __future__ import annotations

import json
import math
import struct
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ICON_DIR = ROOT / "CasinoCompass" / "Assets.xcassets" / "AppIcon.appiconset"

ICON_SPECS = [
    ("iphone", "20x20", "2x", 40),
    ("iphone", "20x20", "3x", 60),
    ("iphone", "29x29", "2x", 58),
    ("iphone", "29x29", "3x", 87),
    ("iphone", "40x40", "2x", 80),
    ("iphone", "40x40", "3x", 120),
    ("iphone", "60x60", "2x", 120),
    ("iphone", "60x60", "3x", 180),
    ("ios-marketing", "1024x1024", "1x", 1024),
]


def lerp(start: int, end: int, progress: float) -> int:
    return round(start + (end - start) * progress)


def set_pixel(pixels: bytearray, size: int, x: int, y: int, color: tuple[int, int, int]) -> None:
    if x < 0 or y < 0 or x >= size or y >= size:
        return
    offset = (y * size + x) * 3
    pixels[offset : offset + 3] = bytes(color)


def draw_disc(pixels: bytearray, size: int, cx: float, cy: float, radius: float, color: tuple[int, int, int]) -> None:
    min_x = math.floor(cx - radius)
    max_x = math.ceil(cx + radius)
    min_y = math.floor(cy - radius)
    max_y = math.ceil(cy + radius)
    radius_squared = radius * radius

    for y in range(min_y, max_y + 1):
        for x in range(min_x, max_x + 1):
            if (x - cx) ** 2 + (y - cy) ** 2 <= radius_squared:
                set_pixel(pixels, size, x, y, color)


def draw_line(
    pixels: bytearray,
    size: int,
    start: tuple[float, float],
    end: tuple[float, float],
    width: float,
    color: tuple[int, int, int],
) -> None:
    distance = max(abs(end[0] - start[0]), abs(end[1] - start[1]))
    steps = max(1, math.ceil(distance))

    for step in range(steps + 1):
        progress = step / steps
        x = start[0] + (end[0] - start[0]) * progress
        y = start[1] + (end[1] - start[1]) * progress
        draw_disc(pixels, size, x, y, width / 2, color)


def draw_circle_outline(
    pixels: bytearray,
    size: int,
    center: tuple[float, float],
    radius: float,
    width: float,
    color: tuple[int, int, int],
) -> None:
    steps = max(96, round(radius * 5))
    previous = None

    for step in range(steps + 1):
        angle = (step / steps) * math.tau
        point = (center[0] + math.cos(angle) * radius, center[1] + math.sin(angle) * radius)
        if previous is not None:
            draw_line(pixels, size, previous, point, width, color)
        previous = point


def point_in_polygon(x: float, y: float, polygon: list[tuple[float, float]]) -> bool:
    inside = False
    j = len(polygon) - 1

    for i, point in enumerate(polygon):
        previous = polygon[j]
        if (point[1] > y) != (previous[1] > y):
            slope_x = (previous[0] - point[0]) * (y - point[1]) / (previous[1] - point[1]) + point[0]
            if x < slope_x:
                inside = not inside
        j = i

    return inside


def fill_polygon(pixels: bytearray, size: int, polygon: list[tuple[float, float]], color: tuple[int, int, int]) -> None:
    min_x = math.floor(min(point[0] for point in polygon))
    max_x = math.ceil(max(point[0] for point in polygon))
    min_y = math.floor(min(point[1] for point in polygon))
    max_y = math.ceil(max(point[1] for point in polygon))

    for y in range(min_y, max_y + 1):
        for x in range(min_x, max_x + 1):
            if point_in_polygon(x + 0.5, y + 0.5, polygon):
                set_pixel(pixels, size, x, y, color)


def write_png(path: Path, size: int, pixels: bytearray) -> None:
    def chunk(kind: bytes, data: bytes) -> bytes:
        return (
            struct.pack(">I", len(data))
            + kind
            + data
            + struct.pack(">I", zlib.crc32(kind + data) & 0xFFFFFFFF)
        )

    raw_rows = bytearray()
    row_length = size * 3
    for y in range(size):
        raw_rows.append(0)
        start = y * row_length
        raw_rows.extend(pixels[start : start + row_length])

    png = bytearray(b"\x89PNG\r\n\x1a\n")
    png.extend(chunk(b"IHDR", struct.pack(">IIBBBBB", size, size, 8, 2, 0, 0, 0)))
    png.extend(chunk(b"IDAT", zlib.compress(bytes(raw_rows), level=9)))
    png.extend(chunk(b"IEND", b""))
    path.write_bytes(png)


def draw_icon(size: int) -> bytearray:
    pixels = bytearray(size * size * 3)

    top = (10, 17, 22)
    middle = (8, 82, 47)
    bottom = (207, 174, 72)

    for y in range(size):
        progress = y / max(size - 1, 1)
        if progress < 0.62:
            local = progress / 0.62
            color = tuple(lerp(top[index], middle[index], local) for index in range(3))
        else:
            local = (progress - 0.62) / 0.38
            color = tuple(lerp(middle[index], bottom[index], local) for index in range(3))
        for x in range(size):
            vignette = math.hypot((x / size) - 0.5, (y / size) - 0.5)
            shade = max(0.72, 1 - vignette * 0.45)
            set_pixel(pixels, size, x, y, tuple(max(0, min(255, round(channel * shade))) for channel in color))

    center = size / 2
    ring_width = max(2, round(size * 0.026))
    ring_margin = size * 0.155
    ring_radius = center - ring_margin
    draw_circle_outline(pixels, size, (center, center), ring_radius, ring_width, (236, 247, 236))

    for angle in range(0, 360, 45):
        radians = math.radians(angle - 90)
        outer = size * 0.385
        inner = size * (0.335 if angle % 90 else 0.305)
        start = (center + math.cos(radians) * inner, center + math.sin(radians) * inner)
        end = (center + math.cos(radians) * outer, center + math.sin(radians) * outer)
        draw_line(pixels, size, start, end, max(1, round(size * 0.011)), (236, 247, 236))

    arrow = [
        (center, size * 0.145),
        (size * 0.64, size * 0.61),
        (center, size * 0.515),
        (size * 0.36, size * 0.61),
    ]
    fill_polygon(pixels, size, arrow, (86, 242, 157))

    shadow = [
        (center, size * 0.855),
        (size * 0.59, size * 0.57),
        (center, size * 0.63),
        (size * 0.41, size * 0.57),
    ]
    fill_polygon(pixels, size, shadow, (12, 28, 28))

    draw_disc(pixels, size, center, center, size * 0.055, (236, 247, 236))

    return pixels


def main() -> None:
    ICON_DIR.mkdir(parents=True, exist_ok=True)

    images = []
    for idiom, point_size, scale, pixel_size in ICON_SPECS:
        filename = f"AppIcon-{pixel_size}.png"
        write_png(ICON_DIR / filename, pixel_size, draw_icon(pixel_size))
        images.append(
            {
                "filename": filename,
                "idiom": idiom,
                "scale": scale,
                "size": point_size,
            }
        )

    contents = {
        "images": images,
        "info": {
            "author": "xcode",
            "version": 1,
        },
    }
    (ICON_DIR / "Contents.json").write_text(json.dumps(contents, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
