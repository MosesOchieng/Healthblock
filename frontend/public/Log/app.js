document.addEventListener("DOMContentLoaded", async () => {
    if (window.ethereum) {
        window.web3 = new Web3(ethereum);
        try {
            // Request account access
            await ethereum.enable();
            initContract();
        } catch (error) {
            console.error("User denied account access");
        }
    } else if (window.web3) {
        window.web3 = new Web3(web3.currentProvider);
        initContract();
    } else {
        console.error("No Ethereum browser extension detected");
    }
});

async function initContract() {
    const networkId = await web3.eth.net.getId();
    const contractData = SpruceIDContract.networks[networkId];
    if (contractData) {
        window.spruceIDContract = new web3.eth.Contract(
            SpruceIDContract.abi,
            contractData.address
        );
    } else {
        console.error("SpruceIDContract not deployed to the detected network");
    }
}

async function createSpruceID() {
    const username = document.getElementById("username").value;
    try {
        const accounts = await web3.eth.getAccounts();
        await spruceIDContract.methods.createSpruceID(username).send({ from: accounts[0] });
        alert("Spruce ID created successfully!");
    } catch (error) {
        console.error("Error creating Spruce ID:", error);
    }
}

async function verifyIdentity() {
    try {
        const accounts = await web3.eth.getAccounts();
        const isVerified = await spruceIDContract.methods.isIdentityVerifiedForUser(accounts[0]).call();
        document.getElementById("verificationStatus").textContent = isVerified ? "Verified" : "Not Verified";
        
        // Redirect to verification result page if verified
        if (isVerified) {
            window.location.href = 'Dashboard/index.html';
        }
    } catch (error) {
        console.error("Error verifying identity:", error);
    }
}

async function renewUsername() {
    const renewUsername = document.getElementById("renewUsername").value;
    try {
        const accounts = await web3.eth.getAccounts();
        await spruceIDContract.methods.renewUsername(renewUsername).send({ from: accounts[0] });
        alert("Username renewed successfully!");
    } catch (error) {
        console.error("Error renewing username:", error);
    }
}
