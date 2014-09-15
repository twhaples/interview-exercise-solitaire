# Solitaire
The Klondike version.

## Installation
Choose a Ruby environment (e.g. `rvm use ruby-2.1.2@twhaples` or something) and run

    bundle install

## Usage
### To play the game

    bin/sol

### To run the tests
    rake
## Notes

 * At the center of this simulation is a `Sol::Deck` that holds 52 `Sol::Card` instances.
The deck's layout is assumed to be fixed, facilitating the location of individual cards.
For a larger project the deck would probably benefit from some more abstraction and its
own lookup interface so things aren't as tightly coupled, but it seemed overkill for the
time being.

 * The `Sol::Session` represents an individual game, which is comprised of several `Sol::Pile`
instances: the stack, waste, and discard piles, plus a faceup and a facedown pile for each
of what the user perceives as the main gameplay piles. Gameplay consists of moving cards
around between these piles. Each class of pile is responsible for the business rules
`.can_pickup?(card)` and, for addressible piles, `.can_putdown(cards)`. Piles are also
responsible for manipulating the property `card.pile` on cards as they enter and exit,
maintaing the accuracy of the card-lookup system.

 * The main loop in `Sol::Bin` executes a series of commands provided by the `Sol::Parser`.
The commands are responsible for things like moving commands between piles, and upon
execution return advice about whether or not the gameboard needs to be redrawn, or
whether it's time to quit, or any messages to convey to the user. Drawing the game
board is the responsibility of the `Sol::Renderer`, which should be encapsulated
well enough that it'd be really easy to subclass it and add ANSI colors or unicode
suit-symbols or HTML or communication with a GUI, without breaking stuff. (Likewise
the parser could be replaced with something that uses, say, Term::Readline, or the
whole event loop could be replaced with something more suitable for a client/server
app.)

 * A couple gem-dependencies of note. `Virtus` is essentially a DSL for your
objects and saves a little effort in the constructors (we're in Ruby, so we might as
well milk that for all it's worth with high-quality third-party metaprogramming!)
The test suite also makes use of `Test::Redef`, an awesome little gadget. Its approach
is not without drawbacks but can turn a complicated mock-object setup into just one or
two lines if you only want to fake a couple methods for a quick pipeline test.

 * Peruse the test suite and the git log for additional commentary: `git log`, `git log --pretty --graph --oneline`
(yay feature branches)

## Known Limitations, Compromises, etc
In the absence of advice to the contrary, I don't actually care about these things in
a codebase of this scope, but it is possible that they could matter to others in the
organization who have opinions.

### Product features
 * Nothing special happens on victory (or defeat).

 * Screen layout does not match sample output character-for-character.
Also, input is case-sensitive. I think it makes more sense this way. 
Agile practices suggest coding to story and not to spec. Regrettably
I don't have a product-manager, or other person in a customer role,
to have a conversation with, so I'm going with my gut.

### Implementation details
 * The code is in Ruby. It was a very convenient programming language with
extensive testing capabilities and no limitations that seemed to matter here.

 * Comments are minimal. See the test suite instead. This is the canonical
Extreme Programming approach.

 * In a longer-lived project, I'd want to spend time writing additional testing
utilities for setting up suites of test objects or validating multi-part operations
(like moving cards between piles. or worse, _not_ moving cards betwen piles.)
Unfortunately rspec is not a magic bullet here, and writing such matchers is
enough of an effort that they'd probably deserve their own unit tests. (Setting up
object suites could be a nice side-effect of writing a save-game capability, though.)
I *have* made extensive use of the layout generated from an unshuffled deck -- a
perfectly legitimate game, if a little freakish, and very deterministic.

 * There are no acceptance tests which launch bin/sol and feed it input on stdin.
Besides being overkill, a deterministic game-board would be also be nice to have
before this happens. (Use that save-game capability, perhaps.)

 * Private methods. Don't think I've written any.

 * Some tests are more white-box than theoretically ideal, especially when it was convenient
to fiddle with the state of cards. The "move cards" command is getting kind of long and
straddles the line between being unit-test-y and integration-test-y. If it gets any longer
it ought to be broken up.

 * There's probably some fiddling to do with the gem layout which would make it gemmier, or
something. This packaging is one small part of Ruby that I haven't used a bunch.
