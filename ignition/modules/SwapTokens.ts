import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SwapTokenModule = buildModule("SwapTokenModule", (m) => {
  const nairaToken = m.contract("NairaToken", ["0xdf3A9C7bed041f90c51452a2B03cE44b80aF2E2F"]);

  const usdtToken = m.contract("UsdtToken", ["0xdf3A9C7bed041f90c51452a2B03cE44b80aF2E2F"]);

  const tokenSwap = m.contract("SwapToken", [nairaToken, usdtToken]);



  return { tokenSwap };
});

export default SwapTokenModule;



