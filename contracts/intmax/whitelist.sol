// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.4;

import "./verifier.sol";

/**
 * @title WhitelistManager
 * @dev Contract that manages a whitelist based on UltraPlonk proof verification
 */
contract WhitelistManager is BaseUltraVerifier {
    // Mapping to track whitelisted addresses
    mapping(uint256 => bool) public isWhitelisted;
    
    // Event emitted when an address is whitelisted
    event AddressWhitelisted(uint256 indexed account);
    
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
     * @param addressToWhitelist The address to whitelist if proof verification succeeds (INTMAX address, 256 bit)
     * @return success Whether the proof verification and whitelisting was successful
     * @notice Security: proof and addressToWhitelist should be contrained within the proof.
     *         This function is not secure if the address is not constrained within the proof.
     *         Be deliberatly missed it for now to show PoC.
     */
    function verifyAndWhitelist(
        bytes calldata proof,
        bytes32[] calldata publicInputs,
        uint256 addressToWhitelist
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
}
