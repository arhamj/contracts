# @version ^0.3.1

from vyper.interfaces import ERC20

token: public(ERC20)
beneficiary: public(address)
releaseTime: public(uint256)

@external
def __init__(_token: address, _beneficiary: address, _releaseTime: uint256):
    """
    @notice Initializes this contract.
    @param _token The address of the ERC20 token to create a timelock.
    @param _beneficiary The wallet address of the beneficiary who will receive the token after the release time.
    @param _releaseTime The block on which the token timelock will end.
    """
    assert _releaseTime > block.timestamp, "Invalid value for release time."
    self.token = ERC20(_token)
    self.beneficiary = _beneficiary
    self.releaseTime = _releaseTime

@external
def release():
    """
    @notice Transfers tokens held by timelock to beneficiary.
    """
    assert msg.sender == self.beneficiary, "Access is denied."
    assert block.timestamp >= self.releaseTime, "Access is denied. It's too early to withdraw your tokens."
    amount : uint256 = self.token.balanceOf(self)
    assert amount > 0, "Nothing to withdraw."
    assert self.token.transfer(self.beneficiary, amount), "Sorry but the transaction was reverted due to an unknown error."