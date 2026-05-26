### To Run use:
`cd AnonComplaint`
`npm run dev`

### Smart Contract Deployment Order

Deploy in the following order:

1. **UserRegistry**
2. **OrganisationRegistry**
3. **ReputationCalculation**
4. **ComplaintRegistry** - pass the addresses of the above three contracts into the constructor
5. Call `setComplaintRegistry` on **ReputationCalculation**, passing the **ComplaintRegistry** address

### Used SolidJs for the frontend
https://www.solidjs.com/

### Used Ethers for connection to metamask
https://docs.ethers.org/v5/

### Notes
- Allman style **ONLY** >:( expect for structs and one line operations (because Allman rules)
- Make sure to update the `AnonComplaint/src/abis` dir on recompilation of contracts (abi compiled files can be found in the `artifacts/contracts` dir)
- contract address are in `AnonComplaint/src/.env` file, make sure to update on redeployments