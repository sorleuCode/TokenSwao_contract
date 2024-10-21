// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library VestingLib {
    struct VestingSchedule {
        uint256 start;
        uint256 duration;
        uint256 totalAmount;
        uint256 releasedAmount;
    }

    function releasableAmount(VestingSchedule storage schedule) internal view returns (uint256) {
        if (block.timestamp < schedule.start) {
            return 0;
        }

        uint256 timeElapsed = block.timestamp - schedule.start;
        uint256 vestingTime = schedule.duration;
        uint256 vestedAmount;

        if (timeElapsed >= vestingTime) {
            vestedAmount = schedule.totalAmount;
        } else {
            vestedAmount = (schedule.totalAmount * timeElapsed) / vestingTime;
        }

        return vestedAmount - schedule.releasedAmount;
    }

    function release(VestingSchedule storage schedule, uint256 amount) internal {
        require(amount <= releasableAmount(schedule), "Insufficient vested tokens");
        schedule.releasedAmount += amount;
    }
}