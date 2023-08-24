# MXHX Component

A macro library for developing compile-time components with [MXHX](https://mxhx.dev/).

This library provides the [core language tags](https://mxhx.dev/learn/language-tags/) the [core language types](https://mxhx.dev/learn/core-types/) only. To build GUIs with MXHX, another library that uses mxhx-component as a dependency is needed to provide a [manifest](https://mxhx.dev/learn/manifests/) of GUI components. Some examples:

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
