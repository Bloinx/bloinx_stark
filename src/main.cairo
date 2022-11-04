// ______   _        _______ _________ _
// (  ___ \ ( \      (  ___  )\__   __/( (    /||\     /|
// | (   ) )| (      | (   ) |   ) (   |  \  ( |( \   / )
// | (__/ / | |      | |   | |   | |   |   \ | | \ (_) /
// |  __ (  | |      | |   | |   | |   | (\ \) |  ) _ (
// | (  \ \ | |      | |   | |   | |   | | \   | / ( ) \
// | )___) )| (____/\| (___) |___) (___| )  \  |( /   \ )
// |/ \___/ (_______/(_______)\_______/|/    )_)|/     \|
//

%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp, deploy
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_check,
    uint256_sqrt,
    uint256_le,
    uint256_lt,
    uint256_eq,
)

from starkware.cairo.common.bool import TRUE, FALSE
from openzeppelin.access.accesscontrol.library import AccessControl
from openzeppelin.utils.constants import DEFAULT_ADMIN_ROLE
// import ISavingGroups
// import IBLXToken

@event
func RoundCreated(round: felt, index: felt) {
}

@storage_var
func salt() -> (value: felt) {
}

@storage_var
func contract_class_hash() -> (value: felt) {
}

@storage_var
func devFund() -> (res: felt) {
}

@storage_var
func fee() -> (res: felt) {
}

@storage_var
func admin() -> (account: felt) {
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _admin: felt, _contract_class: felt
) {
    AccessControl.initializer();
    AccessControl._grant_role(DEFAULT_ADMIN_ROLE, admin);

    contract_class_hash.write(value=_contract_class);
    salt.write(1);
    admin.write(_admin);

    return ();
}

func createRounds{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _warranty: Uint256,
    _saving: Uint256,
    _group_size: felt,
    _admin_fee: Uint256,
    _pay_time: felt,
    _token_payment: felt,
    _blx_address: felt,
) -> (address: felt) {
    // Se inicializan las interfaces
    // Iblx=IAccessControl(_blxaddr);
    // blx=BLXToken(_blxaddr);

    // set up contract information
    let (current_salt) = salt.read();
    let (class_hash) = contract_class_hash.read();
    let (fee) = fee.read();
    let (devFund) = devFund.read();
    let (sender) = get_caller_address();

    // https://www.cairo-lang.org/docs/hello_starknet/deploying_from_contracts.html
    let (new_round) = deploy(
        class_hash,
        contract_address_salt=current_salt,
        constructor_calldata_size=10,
        constructor_calldata=cast(new (_warranty, _saving, _group_size, sender, _admin_fee, _pay_time, _token_payment, blx, devFund, fee), felt*),
        deploy_from_zero=FALSE,
    );

    salt.write(current_salt + 1);
    RoundCreated.emit(newRound, current_salt);

    return (address=newRound);
}

@external
func setDevFund{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _devFundAddress: felt
) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    devFund.write(_devFundAddress);

    return ();
}

@external
func getDevFund{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    address: felt
) {
    let (devFund) = devFund.read();

    return (address=devFund);
}

@external
func setFee{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(_fee: Uint256) {
    AccessControl.assert_only_role(DEFAULT_ADMIN_ROLE);
    fee.write(_fee);

    return ();
}

@external
func getFee{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (fee: felt) {
    let (fee) = fee.read();
    return (fee);
}
