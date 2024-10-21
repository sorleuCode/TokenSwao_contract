// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./VestingLib.sol";
import {IERC20} from "./IERC20.sol";

contract TokenVesting {
    using VestingLib for VestingLib.VestingSchedule;

    mapping(address => VestingLib.VestingSchedule) private beneficiaries;

    address public token;

    constructor(address _token) {
        token = _token;
    }

    function addBeneficiary(address beneficiary, uint256 start, uint256 duration, uint256 totalAmount) external {
        require(beneficiaries[beneficiary].totalAmount == 0, "Beneficiary already exists");

        beneficiaries[beneficiary] = VestingLib.VestingSchedule({
            start: block.timestamp + start,
            duration: duration,
            totalAmount: totalAmount,
            releasedAmount: 0
        });
    }

    function claimTokens() external {
        VestingLib.VestingSchedule storage schedule = beneficiaries[msg.sender];
        uint256 amountToRelease = schedule.releasableAmount();
        require(amountToRelease > 0, "No tokens available for release");

        schedule.release(amountToRelease);

        IERC20(token).transfer(msg.sender, amountToRelease);
    }

    function getReleasableAmount(address beneficiary) external view returns (uint256) {
        return beneficiaries[beneficiary].releasableAmount();
    }
}

