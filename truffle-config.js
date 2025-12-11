module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,      // ou 8545 selon ton Ganache
      network_id: "*",
    },
  },
  contracts_build_directory: "./src/artifacts/",

  compilers: {
    solc: {
      version: "0.8.21",
      settings: {
        optimizer: { enabled: false, runs: 200 },
        evmVersion: "byzantium"
      }
    }
  }
};
