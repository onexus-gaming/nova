# nova
simple and effective framework to make games with love2d, successor to novum

**NOTE**: this repository cannot be run directly.

**NOTE**: this module must be placed in the `lib/` library along with its dependencies.

## quickstart

automated tools for initializing a nova project

### without novatools

in a `bash`-compliant shell with `curl` installed, targeting a dedicated folder/initialized git repository, run

```sh
bash <(curl -s https://onexus-gaming.github.io/nova/install.sh)
```

and respond to the questions.

## dependencies

some dependencies listed here require specific formatting and cannot be dropped in immediately. notes for manual installation are provided under each point if necessary.

* [binser](https://github.com/bakpakin/binser)
  * download `binser.lua` as `lib/binser/init.lua`
* [classic](https://github.com/rxi/classic)
  * download `classic.lua` as `lib/classic/init.lua`
