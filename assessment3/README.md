### To Run use:
`cd AnonComplaint`
`npm run dev` or `npm start`

### Smart Contract Deployment Order

Deploy in the following order:

1. **UserRegistry**
2. **OrganisationRegistry**
3. **ReputationCalculation**
4. **ComplaintRegistry** - pass the addresses of the above three contracts into the constructor
5. Call `setComplaintRegistry` on **ReputationCalculation**, passing the **ComplaintRegistry** address

### Uses SolidJs for the frontend
https://www.solidjs.com/

### Uses Ethers for connection to metamask
https://docs.ethers.org/v5/
