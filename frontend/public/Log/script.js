document.getElementById("verifyBtn").addEventListener("click", async () => {
    // Check if Web3 is available
    if (typeof web3 === 'undefined') {
        console.error("Web3 is not connected. Make sure you're using a compatible browser or MetaMask.");
        return;
    }

    // Replace with the actual SpruceID ABI and address
    const spruceIDABI = [ [
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
	]];
    const spruceIDAddress = "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"; // your SpruceID contract address here

    try {
        // Connect to the SpruceID contract
        const spruceIDContract = new web3.eth.Contract(spruceIDABI, spruceIDAddress);

        // Call the createSpruceID function from SpruceID contract
        const accounts = await web3.eth.getAccounts();
        await spruceIDContract.methods.createSpruceID().send({ from: accounts[0] });

        // After successful verification, redirect to the dashboard
        window.location.href = " ../Dashboard/index.html";
    } catch (error) {
        console.error("Error verifying identity:", error);
    }
});
