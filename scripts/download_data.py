"""Download NYC TLC yellow taxi Parquet files into a Hive-partitioned layout.

    data/raw/yellow_tripdata/year=2024/month=01/data.parquet

Usage:
    python scripts/download_data.py --year 2024 --months 1 2 3

Later exercise: upload data/raw to S3 (aws s3 sync) and point sources.yml at s3://...
"""
import argparse
import urllib.request
from pathlib import Path

BASE_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_{year}-{month:02d}.parquet"
ZONES_URL = "https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--year", type=int, default=2024)
    parser.add_argument("--months", type=int, nargs="+", default=[1])
    parser.add_argument("--out", default="data/raw/yellow_tripdata")
    parser.add_argument("--zones", action="store_true", help="also download the full zone lookup CSV into seeds/")
    args = parser.parse_args()

    for month in args.months:
        dest = Path(args.out) / f"year={args.year}" / f"month={month:02d}" / "data.parquet"
        if dest.exists():
            print(f"skip {dest}")
            continue
        dest.parent.mkdir(parents=True, exist_ok=True)
        url = BASE_URL.format(year=args.year, month=month)
        print(f"downloading {url}")
        urllib.request.urlretrieve(url, dest)

    if args.zones:
        print("downloading zone lookup (columns need renaming to match the seed header)")
        urllib.request.urlretrieve(ZONES_URL, "seeds/taxi_zone_lookup_full.csv")


if __name__ == "__main__":
    main()
