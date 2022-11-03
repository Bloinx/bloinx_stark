# Bloinx Cairo Contracts Version 0.1.0

## [Website](https://bloinx.io)

* What is Bloinx?

Bloinx is a Decentralized application that will help people manage rotating credit and saving associations

* How it Works?

<a href="https://youtu.be/gS0B_wRf5RA" target="_blank">
<img src="https://bloinx.io/static/media/BloinxLogo.c651f886.png"
alt="Bloinx Video" width="120" height="60"/>
Check 2 mins Video
</a>  


## Smart Contracts

Two principal contracts, first one is the `main.cairo` this is a Factory Pattern Contract that deploys the second contract `saving_groups.cairo` the Factory Contract contains the logic for setting the parameters of the new Round and emit an event each time the `createRounds` and returns the address of the new saving_groups contract.

The Saving Groups contract has all the logic for the operation of the round, taking the parameters sends from the Factory contract by the user.

* [More about the Docs](https://github.com/Bloinx/bloinx-Documentation/blob/main/for-developers/smart-contracts-documentation.md)
