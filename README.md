# Make pull request with hub and magit

Not really much to say this simply allows you to make a pull request using
[hub](https://hub.github.com/) and [magit](https://magit.vc/)

## Usage

You simply using the command interactively `mpr-make-pull-request` it will ask you for :

* The origin remote against where you want make the pull request
* Your user remote name fork where you are have pushed or going to push your
  changes.
* The branch name in your origin remote against which you are going to make your
  pull request from (usually `main` or `master`).
* Wether push --force your change to the user remote fork.

It will then fire the hub command with the [editor library
](https://github.com/magit/with-editor) so you are editing your pull request in
emacs directly and create the pull request

## Advanced Usage

You can as well simply make your own command with your usual argument i.e:

```lisp
(defun make-pull-request-against-my-fork ()
  (interactive)
  (message "Forking: %s" (process-lines "hub" "fork"))
  (mpr-make-pull-request "origin" "myusernameremote" "main" t))
```

and call it interactively `make-pull-request-against-my-fork` or bind to an
[hydra menu](https://github.com/abo-abo/hydra) or a keybinding or even to a key
inside magit the choices are unlimited...
