# GeoChain
Location enabled smart contracts on the ethereum network.  

Within the Contracts folder is a smart contract built with solidity for placing location data on the blockchain and veryifying location data.  It allows for incentives and disincnetives to easily be created by anybody on the ethereum network for visiting or not visiting certain physical addresses.  Addresses are handled as a single string and can easily be mapped from latitude and longitude using a reverse geocaching library (we used Apple's Core Location service)

The rest of this repository contains code for a simple use case.  We have created a simple IOS app that allows users to both create incentives and to check in at locations.  

The contract is live on the Rinkeby test network.  Before we deploy to main ethereum network we need to create into the contract two factor location authentication to prevent location spoofing.


# How we built it
Solidity, Swift, Core Location, web3swift
# How we tested it
Rinkeby test net, MetaMask

# Created at BitCamp 2018 by:
Alex Wallish and Ryan Wheeler
