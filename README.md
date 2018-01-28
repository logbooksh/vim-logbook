# vim-logbook

`vim-logbook` provides key mappings for creating and editing Logbooks directly
from vim.

## On Logbooks

Logbooks are plain text files used to capture thoughts and activities as they
occur throughout the day without interrupting flow as much as possible.

The rather minimalistic syntax is optimized for readability and quick editing
without the need for anything fancier than a good text editor.

Here is an example:

```
[Date: 2018-01-30]
[Project: logbook.sh]

Those are page properties. They apply to the whole file and will be automatically
merged with task properties as described below.

[10:00]

This is a log entry. A log entry is the simplest form of entry, it is only
composed of a time and a note. Log entries can be used to capture thoughts and
findings that are not necessarily related to any particular task.

[ToDo] Add README for vim-logbook
       [ID: abcd-1234] [Release: v0.1]
       #vim-logbook #documentation

This is a task definition. A task definition is composed of a header and a note.
The header defines the task, giving it a status, a title and properties.

Properties can either be of the form [Name: Value] or #tag.

Page properties are automatically added to task definitions and
entries that follow them. If a property is defined both for the whole page and
a given task, the task property prevails.

Following the header is a note, which usually describes the task or
activity. The note captures all text until the next task header.

[10:15] [Start] Add README for vim-logbook
                [ID: abcd-1234]

This is a task entry. A task entry is identical to a task definition except
it is prefixed with the time at which the entry was created.

ID is a special property used to identify entries related to the same task
therefore it must be repeated for each entry.

Taken altogether, task definitions and task entries related to the same task
define the task, its properties and current status.

[10:30] [Pause] Add README for vim-logbook
                [ID: abcd-1234]

By appending task entries one after another, we capture activities throughout
the day. As a by-product, we capture the amount of time spent on each task
and their current status.
```

**Note: until 1.0 the syntax is considered unstable and any version upgrade may lead to breaking changes.**

Read more about logbooks and their intended use for software engineering:
- [On Logbooks and Computer Science](https://medium.com/@jlouis666/on-logbooks-e2380ab2f8f0)
- [Using a logbook to improve your programming](https://routley.io/tech/2017/11/23/logbook.html)

## logbook-cli

[logbook-cli](https://github.com/logbooksh/logbook-cli) is a companion
command-line tool used to extract interesting statistics from a collection of
logbook files, such as the amount of time logged per day, per task, and so-on.

## Installation

It is recommended to use a plugin manager for vim, for example
[vim-pathogen](https://github.com/tpope/vim-pathogen).

vim must be compiled with Ruby support:

```console
$ vim --version | grep ruby
+ruby
```

`vim-logbook` was tested on Ruby 2.4 but anything 2.X probably works fine.

Installing it is then straightforward:

```console
$ cd ~/.vim/bundle
$ git clone git@github.com:logbooksh/vim-logbook.git
$ cd vim-logbook
$ bundle install
```

## Usage

`vim-logbook` relies on file-type detection and will only work for files
with either the `.logbook` or `.plan` extension.

Out of the box, `vim-logbook` provides 7 key mappings:

### Key mappings for logs

  * `<Leader>ll`: Append a log entry

### Key mappings for tasks

  * `<Leader>lt`: Append a new task definition with the `ToDo` status
  * `<Leader>lS`: Append a new task entry with the `Start` status
  * `<Leader>ls`: Append a task entry with the `Start` status for the task under cursor
  * `<Leader>lp`: Append a task entry with the `Pause` status for the task under cursor
  * `<Leader>lr`: Append a task entry with the `Resume` status for the task under cursor
  * `<Leader>ld`: Append a task entry with the `Done` status for the task under cursor

## Changelog

### 0.1

  * Automatic detection of file type based on .logbook and .plan extensions
  * Basic syntax highlighting
  * Key mappings to append new log and task entries
  * Key mappings to append task entries based on the task under cursor

## License

`vim-logbook` is under the Apache License 2.0. See [`LICENSE`](LICENSE) for more
information.
