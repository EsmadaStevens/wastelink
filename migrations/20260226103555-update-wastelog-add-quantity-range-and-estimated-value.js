'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.addColumn("WasteLogs", "quantityRange", {
    type: Sequelize.STRING,
    allowNull: false,
  });

  await queryInterface.addColumn("WasteLogs", "estimatedValue", {
    type: Sequelize.FLOAT,
    allowNull: false,
    defaultValue: 0,
  });
    /**
     * Add altering commands here.
     *
     * Example:
     * await queryInterface.createTable('users', { id: Sequelize.INTEGER });
     */
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.removeColumn("WasteLogs", "quantityRange");
  await queryInterface.removeColumn("WasteLogs", "estimatedValue");
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
  }
};
