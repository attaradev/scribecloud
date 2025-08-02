import argparse
from cli.auth import configure
from cli.translate import translate_text

def main():
    parser = argparse.ArgumentParser(prog="scribecloud", description="ScribeCloud CLI")
    subparsers = parser.add_subparsers(dest="command")

    subparsers.add_parser("configure", help="Authenticate with ScribeCloud")

    t = subparsers.add_parser("translate", help="Translate text")
    t.add_argument("--source", required=True)
    t.add_argument("--target", required=True)
    t.add_argument("--text", required=True)

    args = parser.parse_args()

    if args.command == "configure":
        configure()
    elif args.command == "translate":
        translate_text(args.source, args.target, args.text)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
