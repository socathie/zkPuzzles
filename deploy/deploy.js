module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    await deploy('PlonkVerifier', {
        from: deployer,
        log: true
    });
};
module.exports.tags = ['complete'];
