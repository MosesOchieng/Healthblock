// Replace with the actual ABI of SpruceID contract
const spruceIDABI = [
	[
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
	]
	// ... Copy and paste your SpruceID contract ABI here ...
  ];
  
  // Replace with the actual address of your deployed SpruceID contract
  const spruceIDAddress = "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4";  // SpruceID contract address
  
  // Connect to Ethereum using web3.js, and set up a signer (e.g., with MetaMask)
  window.addEventListener('load', async () => {
	if (window.ethereum) {
	  window.web3 = new Web3(ethereum);
	  try {
		// Request account access if needed
		await ethereum.enable();
		console.log("Connected to Ethereum using MetaMask.");
	  } catch (error) {
		console.error("User denied account access:", error);
	  }
	} else if (window.web3) {
	  window.web3 = new Web3(web3.currentProvider);
	  console.log("Connected to Ethereum using injected Web3.");
	} else {
	  console.error("Non-Ethereum browser detected. You should consider trying MetaMask!");
	}
  });
  
  // Authenticate the user
  document.getElementById("verifyBtn").addEventListener("click", async () => {
	if (typeof web3 === 'undefined') {
	  console.error("Web3 is not connected. Make sure you're using a compatible browser or MetaMask.");
	  return;
	}
  
	try {
	  // Connect to the SpruceID contract
	  const spruceIDContract = new web3.eth.Contract(spruceIDABI, spruceIDAddress);
  
	  // Call the createSpruceID function from SpruceID contract
	  const accounts = await web3.eth.getAccounts();
	  const tx = await spruceIDContract.methods.createSpruceID().send({ from: accounts[0] });
  
	  // Wait for the transaction to be mined
	  await tx.wait();
  
	  // After successful verification, redirect to the ENS allocation page
	  window.location.href = "ens_allocation.html";
	} catch (error) {
	  console.error("Error verifying identity:", error);
	}
  });
  
  // Rest of your code...
// Rest of your code...

// Allocate ENS name
document.getElementById("allocateBtn").addEventListener("click", async () => {
	if (typeof web3 === 'undefined') {
	  console.error("Web3 is not connected. Make sure you're using a compatible browser or MetaMask.");
	  return;
	}
  
	const ensNameInput = document.getElementById("ensNameInput").value;
	if (ensNameInput) {
	  try {
		// Connect to the ENSNameAllocation contract
		const ensNameAllocationContract = new web3.eth.Contract(ensNameAllocationABI, ensNameAllocationAddress);
  
		// Call the allocateENSName function from ENSNameAllocation contract
		const accounts = await web3.eth.getAccounts();
		const tx = await ensNameAllocationContract.methods.allocateENSName(ensNameInput).send({ from: accounts[0] });
  
		// Wait for the transaction to be mined
		await tx.wait();
  
		// After successful allocation, redirect to the dashboard page with the allocated ENS name
		window.location.href = `index.html?ensName=${ensNameInput}`;
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
	