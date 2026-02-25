'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    // Add imageUrl column
    await queryInterface.addColumn('WasteLogs', 'imageUrl', {
      type: Sequelize.STRING,
      allowNull: true, 
      // allowNull true so old records don't break
    });

    // Add aiPrediction column
    await queryInterface.addColumn('WasteLogs', 'aiPrediction', {
      type: Sequelize.STRING,
      allowNull: true,
    });

    // Add aiConfidence column
    await queryInterface.addColumn('WasteLogs', 'aiConfidence', {
      type: Sequelize.FLOAT,
      allowNull: true,
    });
    /**
     * Add altering commands here.
     *
     * Example:
     * await queryInterface.createTable('users', { id: Sequelize.INTEGER });
     */
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.removeColumn('WasteLogs', 'imageUrl');
    await queryInterface.removeColumn('WasteLogs', 'aiPrediction');
    await queryInterface.removeColumn('WasteLogs', 'aiConfidence');
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
  }
};
