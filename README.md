# MXHX Component

A macro library for developing compile-time components with [MXHX](https://mxhx.dev/).

This _mxhx-component_ library provides the [core language tags](https://mxhx.dev/learn/language-tags/) the [core language types](https://mxhx.dev/learn/core-types/) of MXHX only. To build GUIs with MXHX, you must install an additional library for the GUI framework of your choice. For example:

- [mxhx-feathersui](https://github.com/mxhx-dev/mxhx-feathersui)
- [mxhx-minimalcomps](https://github.com/mxhx-dev/mxhx-minimalcomps)

## Minimum Requirements

- Haxe 4.0

## Installation

This library is not yet available on Haxelib, so you'll need to install it from Github.

```sh
haxelib git mxhx-component https://github.com/mxhx-dev/mxhx-component.git
```

## Project Configuration

After installing the library above, add it to your Haxe _.hxml_ file.

```hxml
--library mxhx-component
```

For Lime and OpenFL, add it to your _project.xml_ file.

```xml
<haxelib name="mxhx-component" />
```
