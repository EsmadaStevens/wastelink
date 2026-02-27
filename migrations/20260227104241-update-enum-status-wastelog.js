"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.sequelize.query(`
      UPDATE WasteLogs
      SET status = 'pending'
      WHERE status NOT IN ('pending','approved','rejected','collected','pickup_requested')
    `);

    // Step 2: Change ENUM to include 'pickup_requested'
    await queryInterface.changeColumn("WasteLogs", "status", {
      type: Sequelize.ENUM(
        "pending",
        "approved",
        "rejected",
        "collected",
        "pickup_requested",
      ),
      allowNull: false,
      defaultValue: "pending",
    });
    /**
     * Add altering commands here.
     *
     * Example:
     * await queryInterface.createTable('users', { id: Sequelize.INTEGER });
     */
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.changeColumn('WasteLogs', 'status', {
      type: Sequelize.ENUM('pending','approved','rejected','collected'),
      allowNull: false,
      defaultValue: 'pending',
    });
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
  },
};
