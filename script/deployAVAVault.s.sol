// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {AVAVault} from "../src/Vault/AVAVault.sol";
import {ERC20} from "../lib/solmate/src/tokens/ERC20.sol";
import {IStrategy} from "../src/Vault/interfaces/IStrategy.sol";

// [TODO]: Uncomment these lines in your real project and remove the inline Mocks below
// import {AaveStrategy} from "../src/Vault/Strategies/AaveStrategy.sol";
// import {EulerStrategy} from "../src/Vault/Strategies/EulerStrategy.sol";
// import {BenqiStrategy} from "../src/Vault/Strategies/BenqiStrategy.sol";

// -----------------------------------------------------------
// INLINE MOCKS (For standalone script execution)
// -----------------------------------------------------------

contract DeployMockWAVAX is ERC20 {
    constructor() ERC20("Wrapped AVAX", "WAVAX", 18) {}
    function mint(address to, uint256 amount) external { _mint(to, amount); }
}

// Base logic for the mocks
abstract contract BaseMockStrategy is IStrategy {
    ERC20 public immutable assetToken;
    address public immutable vault;
    string public name;

    constructor(address _asset, address _vault, string memory _name) {
        assetToken = ERC20(_asset);
        vault = _vault;
        name = _name;
    }
    function asset() external view returns (address) { return address(assetToken); }
    function deposit(uint256 amount) external { assetToken.transferFrom(msg.sender, address(this), amount); }
    function withdraw(uint256 amount) external { assetToken.transfer(vault, amount); }
    function balance() external view returns (uint256) { return assetToken.balanceOf(address(this)); }
}

// Distinct classes so we can see different addresses in logs
contract MockAaveStrategy is BaseMockStrategy {
    constructor(address _asset, address _vault) BaseMockStrategy(_asset, _vault, "Aave") {}
}
contract MockEulerStrategy is BaseMockStrategy {
    constructor(address _asset, address _vault) BaseMockStrategy(_asset, _vault, "Euler") {}
}
contract MockBenqiStrategy is BaseMockStrategy {
    constructor(address _asset, address _vault) BaseMockStrategy(_asset, _vault, "Benqi") {}
}

// -----------------------------------------------------------
// MAIN DEPLOY SCRIPT
// -----------------------------------------------------------

contract deployAVAVault is Script {
    // Avalanche Mainnet Constants
    address constant MAINNET_WAVAX = 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7;
    
    // Fuji Testnet Constants
    address constant FUJI_WAVAX = 0xd00ae08403B9bbb9124bB305C09058E32C39A48c;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);
        
        vm.startBroadcast(deployerPrivateKey);

        // ---------------------------------------------------------
        // 1. SETUP ASSET (WAVAX)
        // ---------------------------------------------------------
        ERC20 wavax;
        bool isLocal = false;

        if (block.chainid == 43114) { 
            console.log("--- Network: Avalanche Mainnet ---");
            wavax = ERC20(MAINNET_WAVAX);
        } else if (block.chainid == 43113) {
            console.log("--- Network: Fuji Testnet ---");
            wavax = ERC20(FUJI_WAVAX);
        } else {
            console.log("--- Network: Local / Anvil ---");
            isLocal = true;
            DeployMockWAVAX mockToken = new DeployMockWAVAX();
            mockToken.mint(deployerAddress, 1000 ether); // Mint initial supply
            wavax = ERC20(address(mockToken));
        }

        // ---------------------------------------------------------
        // 2. DEPLOY VAULT
        // ---------------------------------------------------------
        AVAVault vault = new AVAVault(
            wavax,
            "Liquid Staked AVAX",
            "lsAVAX"
        );

        // ---------------------------------------------------------
        // 3. DEPLOY STRATEGIES
        // ---------------------------------------------------------
        // In a real deployment, you would pass real Comptroller/Pool addresses here.
        // For this script, we instantiate the Mocks defined above (or your real imports).
        
        IStrategy aaveStrategy;
        IStrategy eulerStrategy;
        IStrategy benqiStrategy;

        // [IMPORTANT]: Swap these lines for your real constructors when ready
        aaveStrategy = new MockAaveStrategy(address(wavax), address(vault));
        eulerStrategy = new MockEulerStrategy(address(wavax), address(vault));
        benqiStrategy = new MockBenqiStrategy(address(wavax), address(vault));

        // ---------------------------------------------------------
        // 4. REGISTER STRATEGIES IN VAULT
        // ---------------------------------------------------------
        
        // Add Aave
        vault.addStrategy(aaveStrategy);
        console.log("-> Registered Aave Strategy");

        // Add Euler
        vault.addStrategy(eulerStrategy);
        console.log("-> Registered Euler Strategy");

        // Add Benqi
        vault.addStrategy(benqiStrategy);
        console.log("-> Registered Benqi Strategy");

        // ---------------------------------------------------------
        // 5. SET ACTIVE STRATEGY
        // ---------------------------------------------------------
        // We set Aave as the default active strategy to receive new deposits
        vault.updateActiveStrategy(aaveStrategy);
        console.log("-> Set Active Strategy: Aave");

        vm.stopBroadcast();

        // ---------------------------------------------------------
        // 6. FINAL DEPLOYMENT LOGS
        // ---------------------------------------------------------
        console.log("\n==============================================");
        console.log("       DEPLOYMENT COMPLETE");
        console.log("==============================================");
        console.log("Network ID     :", block.chainid);
        console.log("Deployer       :", deployerAddress);
        console.log("WAVAX Asset    :", address(wavax));
        console.log("----------------------------------------------");
        console.log(">> AVAVault    :", address(vault));
        console.log("----------------------------------------------");
        console.log(">> Aave Strat  :", address(aaveStrategy));
        console.log(">> Euler Strat :", address(eulerStrategy));
        console.log(">> Benqi Strat :", address(benqiStrategy));
        console.log("==============================================\n");
    }
}