import argparse
from cli.auth import configure
from cli.translate import translate_text


def main():
    parser = argparse.ArgumentParser(
        prog="scribecloud", description="ScribeCloud CLI")

    subparsers = parser.add_subparsers(dest="command", required=True)

    # scribecloud configure
    subparsers.add_parser("configure", help="Authenticate via browser")

    # scribecloud translate --target fr --text "Hello"
    translate_parser = subparsers.add_parser(
        "translate", help="Translate text")
    translate_parser.add_argument(
        "--source", default="en", help="Source language code (default: en)")
    translate_parser.add_argument(
        "--target", required=True, help="Target language code")
    translate_parser.add_argument(
        "--text", help="Text to translate (or use stdin)")
    translate_parser.add_argument(
        "--json", action="store_true", help="Output raw JSON")
    translate_parser.add_argument(
        "--rich", action="store_true", help="Use rich formatting")

    args = parser.parse_args()

    if args.command == "configure":
        configure()
    elif args.command == "translate":
        translate_text(
            source=args.source,
            target=args.target,
            text=args.text,
            output_json=args.json,
            use_rich=args.rich
        )


if __name__ == "__main__":
    main()
