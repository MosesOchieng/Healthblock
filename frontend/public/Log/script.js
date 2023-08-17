// Import the contract ABIs here
const spruceIDABI = [[
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			}
		],
		"name": "IdentityVerified",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "createSpruceID",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "isIdentityVerified",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]];  // Replace with the actual ABI of SpruceID contract
const ensNameAllocationABI = [];  // Replace with the actual ABI of ENSNameAllocation contract

// Replace with the actual addresses of your deployed contracts
const spruceIDAddress = "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4";  // SpruceID contract address
const ensNameAllocationAddress = "0x...";  // ENSNameAllocation contract address

// Authenticate the user
document.getElementById("verifyBtn").addEventListener("click", async () => {
    // Connect to the SpruceID contract
    const spruceIDContract = new ethers.Contract(spruceIDAddress, spruceIDABI, signer); // Replace with your preferred way of connecting

    try {
        // Call the createSpruceID function from SpruceID contract
        const tx = await spruceIDContract.createSpruceID();

        // Wait for the transaction to be mined
        await tx.wait();

        // After successful verification, redirect to the ENS allocation page
        window.location.href = "ens_allocation.html";
    } catch (error) {
        console.error("Error verifying identity:", error);
    }
});

// Allocate ENS name
document.getElementById("allocateBtn").addEventListener("click", async () => {
    const ensNameInput = document.getElementById("ensNameInput").value;
    if (ensNameInput) {
        // Connect to the ENSNameAllocation contract
        const ensNameAllocationContract = new ethers.Contract(ensNameAllocationAddress, ensNameAllocationABI, signer); // Replace with your preferred way of connecting

        try {
            // Call the allocateENSName function from ENSNameAllocation contract
            const tx = await ensNameAllocationContract.allocateENSName(ensNameInput);

            // Wait for the transaction to be mined
            await tx.wait();

            // After successful allocation, redirect to the next page with the allocated ENS name
            window.location.href = `  ../Dashboard/index.html?ensName=${ensNameInput}`;
        } catch (error) {
            console.error("Error allocating ENS name:", error);
        }
    }
});

// Get the allocated ENS name from the URL query parameter and display it
const ensNameSpan = document.getElementById("ensName");
const urlParams = new URLSearchParams(window.location.search);
const allocatedENSName = urlParams.get("ensName");
if (allocatedENSName) {
    ensNameSpan.textContent = allocatedENSName;
}
