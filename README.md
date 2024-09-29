# Blacklist Token

## Overview

`BlacklistToken` is a fungible ERC-20 token implemented on Ethereum, featuring administrative controls that allow specified addresses to be banned from sending and receiving tokens. This functionality is useful for adhering to regulatory requirements and enforcing sanctions.

## Features

- ERC-20 compliance: The token adheres to the standard ERC-20 interface.
- Blacklisting: Admins can add or remove addresses from a blacklist.
- Transfer controls: Blacklisted addresses cannot send or receive tokens.

## Technology

The token is implemented using Solidity 0.8.20 and relies on OpenZeppelin's contracts for standard functionality, including ERC20 and access control.

## Getting Started

### Prerequisites

- Node.js and npm
- Foundry (for local deployment and testing)

### Installation

1. Install Foundry if it's not already installed:
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/jocoders/blacklist-token.git
   cd blacklist-token
   ```

3. Install dependencies:
   ```bash
   forge install
   ```

### Testing

Run tests using Foundry:
```bash
forge test
```

## Usage

### Deploying the Token

Deploy the token to a local blockchain using Foundry:
```bash
forge create BlacklistToken --rpc-url http://localhost:8545
```

### Interacting with the Token

#### Adding to Blacklist

```javascript
const tx = await token.addToBlacklist("0xADDRESS");
await tx.wait();
```

#### Removing from Blacklist

```javascript
const tx = await token.removeFromBlacklist("0xADDRESS");
await tx.wait();
```

#### Transferring Tokens

```javascript
const tx = await token.transfer("0xRECIPIENT", amount);
await tx.wait();
```

## Contributing

Contributions are welcome! Please fork the repository and open a pull request with your features or fixes.

## License

This project is unlicensed and free for use by anyone.