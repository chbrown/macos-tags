import Foundation

func printHelp() {
  // no multiline strings in Swift
  print("Usage: tags read [-v] [--verbose] [file1 ...]")
  print("       tags write [-v] [--verbose] file [tag1 ...]")
}

func readTags(path: String) throws -> [String] {
  let fileURL = NSURL(fileURLWithPath: path)
  var tags: AnyObject?
  try fileURL.getResourceValue(&tags, forKey: NSURLTagNamesKey)
  return tags as? [String] ?? []
}

func writeTags(path: String, _ tags: [String]) throws {
  let fileURL = NSURL(fileURLWithPath: path)
  try fileURL.setResourceValue(tags, forKey: NSURLTagNamesKey)
}

enum ArgumentError: ErrorType {
  case HelpRequested
  case NotEnoughArguments
  case InvalidVerb(found: String)
}

func run(args: [String], verbose: Bool = false) throws {
  guard let verb = args.first else { throw ArgumentError.NotEnoughArguments }
  let rest = args.dropFirst()

  if verb == "read" {
    for path in rest {
      let tags = try readTags(path)
      // only print the filename + tags if there are tags or the verbose flag is set
      if !tags.isEmpty || verbose {
        // I would prefer print(path, ...tags, separator: "\t"), but Swift does
        // not have an array splat operator for variadic function arguments
        print(path, tags.joinWithSeparator("\t"), separator: "\t")
      }
    }
  } else if verb == "write" {
    if let path = rest.first {
      // copy colors to an Array, since setResourceValue won't take an ArraySlice
      let tags = Array(rest.dropFirst())
      try writeTags(path, tags)
      // only print the result if the 'verbose' flag is set, but print it
      // regardless of the tags, since no tag arguments clears existing tags
      if verbose {
        print(tags.joinWithSeparator("\t"))
      }
    }
    else {
      throw ArgumentError.NotEnoughArguments
    }
  } else {
    throw ArgumentError.InvalidVerb(found: verb)
  }
}

do {
  // I wish I could do this argument processing more mutable, but it's kind of clumsy
  var args = Process.arguments
  // Process.arguments.first! is the path of the executed file, so we want to skip that
  args.removeFirst()
  // pull off the -v --verbose flag, if provided
  let verboseIndexOption = args.indexOf { $0 == "-v" || $0 == "--verbose" }
  if let verboseIndex = verboseIndexOption {
    args.removeAtIndex(verboseIndex)
  }
  // handle the -h --help flag before handing off to run()
  guard !args.contains({ $0 == "-h" || $0 == "--help" }) else { throw ArgumentError.HelpRequested }
  try run(args, verbose: verboseIndexOption != nil)
} catch ArgumentError.HelpRequested {
  printHelp()
  // exit successfully, since the user explicitly requested help
} catch ArgumentError.NotEnoughArguments {
  print("ArgumentError: not enough arguments")
  printHelp()
  exit(1)
} catch ArgumentError.InvalidVerb(let found) {
  print("ArgumentError: the first argument must be 'read' or 'write', found '\(found)'")
  printHelp()
  exit(1)
} catch let error as NSError {
  print("Error: \(error.localizedDescription)")
  exit(1)
}
