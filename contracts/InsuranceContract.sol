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
    const contractAddress = "CONTRACT_ADDRESS"; // Replace with your contract address
    const contractAbi = [...]; // Replace with your contract ABI

    window.insuranceContract = new web3.eth.Contract(contractAbi, contractAddress);
}

async function displayPackages() {
    const packagesDiv = document.getElementById("packages");

    const packages = [
        { name: "Basic Package", price: web3.utils.toWei("1", "ether") },
        { name: "Standard Package", price: web3.utils.toWei("2", "ether") },
        { name: "Premium Package", price: web3.utils.toWei("3", "ether") }
    ];

    packages.forEach((packageDetails, index) => {
        const subscribeButton = document.createElement("button");
        subscribeButton.innerText = `Subscribe to ${packageDetails.name} (${web3.utils.fromWei(packageDetails.price, "ether")} ETH)`;
        subscribeButton.addEventListener("click", async () => {
            await subscribe(index, packageDetails.price);
        });
        packagesDiv.appendChild(subscribeButton);
    });
}

async function subscribe(packageIndex, price) {
    try {
        const accounts = await web3.eth.getAccounts();
        await insuranceContract.methods.subscribe(packageIndex).send({
            from: accounts[0],
            value: price
        });
        alert("Congratulations! You've subscribed to the insurance package.");
        location.reload();
    } catch (error) {
        console.error("Error subscribing:", error);
    }
}
