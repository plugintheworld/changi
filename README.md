# Changi

Very tiny.

Helps you maintain a `changelog.md` without constant merge conflicts.

## Installation

Add this to your `Rakefile`:

```
require 'changi'
```

## Usage

### Adding a new changelog entry for the next release

```
rake changi:new
```

Follow the questions.

### Viewing the changelog for the upcoming release.

```
rake changi:diff
```

### Prepending changelog entries to main changelog.md file.

```
rake changi:update
```

This will build a release changelog from your entries and *prepend* that
to your main `changelog.md` file.

It will also try to `git rm` changelog entry files.

Changelog format looks like this:

```
# <release no.>, <date>[, <release notes>]

## <category>

* entry
* entry

## <category 2>

...
```

## Configuration

A Tiny bit of configuration can be done using our most convenient configuration method:

```
# Rakefile (or wherever)
require 'changi'
Changi.configure do |config|
  config.changelog_path = 'changelog.md'
  config.changelog_entry_path = 'changelog'
  config.default_categories = []
end
```
