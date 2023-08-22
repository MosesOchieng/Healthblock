document.addEventListener("DOMContentLoaded", async () => {
    if (window.ethereum) {
        window.web3 = new Web3(ethereum);
        try {
            await ethereum.enable();
            initContract();
            displayPackages();
        } catch (error) {
            console.error("User denied account access");
        }
    } else if (window.web3) {
        window.web3 = new Web3(web3.currentProvider);
        initContract();
        displayPackages();
    } else {
        console.error("No Ethereum browser extension detected");
    }
});

async function initContract() {
    const contractAddress = "0xf8e81D47203A594245E36C48e151709F0C19fBe8"; // Replace with your contract address
    const contractAbi = [[
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": true,
                    "internalType": "address",
                    "name": "user",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "internalType": "string",
                    "name": "packageName",
                    "type": "string"
                }
            ],
            "name": "Subscribed",
            "type": "event"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "packageIndex",
                    "type": "uint256"
                }
            ],
            "name": "subscribe",
            "outputs": [],
            "stateMutability": "payable",
            "type": "function"
        },
        {
            "inputs": [],
            "stateMutability": "nonpayable",
            "type": "constructor"
        },
        {
            "inputs": [],
            "name": "getPackageCount",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "",
                    "type": "uint256"
                }
            ],
            "name": "insurancePackages",
            "outputs": [
                {
                    "internalType": "string",
                    "name": "name",
                    "type": "string"
                },
                {
                    "internalType": "uint256",
                    "name": "price",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
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
            "name": "isSubscribed",
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
    ]]; // Replace with your contract ABI

    window.insuranceContract = new web3.eth.Contract(contractAbi, contractAddress);
}

async function displayPackages() {
    const packagesDiv = document.getElementById("packages");

    const packageNames = ["Basic Package", "Standard Package", "Premium Package"];

    packageNames.forEach(async (packageName, index) => {
        const subscribeButton = document.createElement("button");
        subscribeButton.innerText = `Subscribe to ${packageName}`;
        subscribeButton.style.fontSize = "14px";
        subscribeButton.addEventListener("click", async () => {
            await subscribe(index);
        });
        packagesDiv.appendChild(subscribeButton);
    });
}

async function subscribe(packageIndex) {
    try {
        const accounts = await web3.eth.getAccounts();
        const weiPrice = await insuranceContract.methods.insurancePackages(packageIndex).call({ from: accounts[0] }).price;
        await insuranceContract.methods.subscribe(packageIndex).send({
            from: accounts[0],
            value: weiPrice
        });
        alert("Congratulations! You've subscribed to the insurance package.");
        location.reload();
    } catch (error) {
        console.error("Error subscribing:", error);
    }
}
