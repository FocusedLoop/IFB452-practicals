// ABI's for the smart contracts 

export const OrgRegistryABI = [
  'function registerOrganisation(string name) external returns (uint256)',
  'function getOrganisation(uint256 orgId) external view returns (uint256 id, string name, address owner)',
  'function organisationExists(uint256 orgId) public view returns (bool)',
];