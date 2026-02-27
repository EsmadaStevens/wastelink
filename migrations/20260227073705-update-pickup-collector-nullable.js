'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.changeColumn('PickupRequests', 'collectorId', {
      // type: Sequelize.UUID,
        type: Sequelize.INTEGER,
      allowNull: true
    });
    /**
     * Add altering commands here.
     *
     * Example:
     * await queryInterface.createTable('users', { id: Sequelize.INTEGER });
     */
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.changeColumn('PickupRequests', 'collectorId', {
      // type: Sequelize.UUID,
        type: Sequelize.INTEGER,
      allowNull: true
    });
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
  }
};
