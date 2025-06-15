// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.4;

import "./verifier.sol";

/**
 * @title WhitelistManager
 * @dev Contract that manages a whitelist based on UltraPlonk proof verification
 */
contract WhitelistManager is BaseUltraVerifier {
    // Mapping to track whitelisted addresses
    mapping(address => bool) public isWhitelisted;
    
    // Event emitted when an address is whitelisted
    event AddressWhitelisted(address indexed account);
    
    /**
     * @dev Returns the verification key hash
     * @return bytes32 The verification key hash
     */
    function getVerificationKeyHash() public pure override(BaseUltraVerifier) returns (bytes32) {
        return UltraVerificationKey.verificationKeyHash();
    }

    /**
     * @dev Loads the verification key
     * @param vk The verification key location
     * @param _omegaInverseLoc The omega inverse location
     */
    function loadVerificationKey(uint256 vk, uint256 _omegaInverseLoc) internal pure override(BaseUltraVerifier) {
        UltraVerificationKey.loadVerificationKey(vk, _omegaInverseLoc);
    }
    
    /**
     * @dev Verifies an UltraPlonk proof and whitelists the address if verification succeeds
     * @param proof The UltraPlonk proof to verify
     * @param publicInputs The public inputs for the proof
     * @param addressToWhitelist The address to whitelist if proof verification succeeds
     * @return success Whether the proof verification and whitelisting was successful
     */
    function verifyAndWhitelist(
        bytes calldata proof,
        bytes32[] calldata publicInputs,
        address addressToWhitelist
    ) external returns (bool success) {
        // Verify the UltraPlonk proof
        success = this.verify(proof, publicInputs);
        
        // If verification succeeds, whitelist the address
        if (success) {
            isWhitelisted[addressToWhitelist] = true;
            emit AddressWhitelisted(addressToWhitelist);
        }
        
        return success;
    }
    
    /**
     * @dev Checks if an address is whitelisted
     * @param account The address to check
     * @return bool Whether the address is whitelisted
     */
    function checkWhitelist(address account) external view returns (bool) {
        return isWhitelisted[account];
    }
}
