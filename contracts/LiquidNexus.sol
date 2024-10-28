// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract LiquidNexus is Initializable, ERC20Upgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    // Existing mappings
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public stakingTime;
    mapping(uint256 => mapping(address => uint256)) public pendingCrossChainTransfers;

    // New mappings for staking rewards
    mapping(address => uint256) public rewards;

    // Constants for staking
    uint256 private constant REWARD_RATE = 10; // 10% annual reward rate
    uint256 private constant MIN_STAKE_DURATION = 7 days; // Minimum staking period
    uint256 private constant YEAR_IN_SECONDS = 365 days;

    // Existing events
    event CrossChainTransfer(address indexed from, uint256 amount, uint256 destinationChainId);
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    // New event for claiming rewards
    event RewardClaimed(address indexed user, uint256 amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(string memory name, string memory symbol) public initializer {
    __ERC20_init(name, symbol);
    __Ownable_init(msg.sender);
    __ReentrancyGuard_init();
}


    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, unicode"Cannot stake 0 tokens");
        require(balanceOf(msg.sender) >= amount, unicode"Insufficient balance");
        
        if (stakedBalance[msg.sender] > 0) {
            _updateReward(msg.sender);
        }

        _transfer(msg.sender, address(this), amount);
        stakedBalance[msg.sender] += amount;
        stakingTime[msg.sender] = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external nonReentrant {
        require(amount > 0, unicode"Cannot withdraw 0 tokens from stake");
        require(stakedBalance[msg.sender] >= amount, unicode"Insufficient staked balance");
        require(block.timestamp >= stakingTime[msg.sender] + MIN_STAKE_DURATION, unicode"Minimum staking period not met");
        
        _updateReward(msg.sender);
        
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        
        stakedBalance[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
        
        if (reward > 0) {
            _mint(msg.sender, reward);
        }

        emit Unstaked(msg.sender, amount);
        if (reward > 0) {
            emit RewardClaimed(msg.sender, reward);
        }
    }

    function claimReward() external nonReentrant {
        _updateReward(msg.sender);
        uint256 reward = rewards[msg.sender];
        require(reward > 0, unicode"No rewards to claim");
        
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);

        emit RewardClaimed(msg.sender, reward);
    }

    function _updateReward(address account) internal {
        uint256 timeElapsed = block.timestamp - stakingTime[account];
        uint256 reward = (stakedBalance[account] * REWARD_RATE * timeElapsed) / (YEAR_IN_SECONDS * 100);
        rewards[account] += reward;
        stakingTime[account] = block.timestamp;
    }

    function getTotalStaked(address account) external view returns (uint256) {
        return stakedBalance[account];
    }

    function getStakingTime(address account) external view returns (uint256) {
        return block.timestamp - stakingTime[account];
    }

    function getPendingReward(address account) external view returns (uint256) {
        uint256 timeElapsed = block.timestamp - stakingTime[account];
        uint256 pendingReward = (stakedBalance[account] * REWARD_RATE * timeElapsed) / (YEAR_IN_SECONDS * 100);
        return rewards[account] + pendingReward;
    }

    function crossChainTransfer(uint256 amount, uint256 destinationChainId) external nonReentrant {
        require(amount > 0, unicode"Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, unicode"Insufficient balance");

        _burn(msg.sender, amount);
        pendingCrossChainTransfers[destinationChainId][msg.sender] += amount;

        emit CrossChainTransfer(msg.sender, amount, destinationChainId);

        // Here you would call a function of a cross-chain bridge contract
        // For example: bridgeContract.initiateCrossChainTransfer(msg.sender, amount, destinationChainId);
    }

    function receiveCrossChainTransfer(address to, uint256 amount) external onlyOwner nonReentrant {
        // In practice, you should implement additional security checks here
        _mint(to, amount);
    }

    function cancelCrossChainTransfer(uint256 destinationChainId) external nonReentrant {
        uint256 amount = pendingCrossChainTransfers[destinationChainId][msg.sender];
        require(amount > 0, unicode"No pending transfer");

        pendingCrossChainTransfers[destinationChainId][msg.sender] = 0;
        _mint(msg.sender, amount);
    }
}