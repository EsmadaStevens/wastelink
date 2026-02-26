'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    // await queryInterface.removeColumn('Users', 'otp');
    await queryInterface.removeColumn('Users', 'otpExpires');
    await queryInterface.removeColumn('Users', 'isVerified');
    /**
     * Add altering commands here.
     *
     * Example:
     * await queryInterface.createTable('users', { id: Sequelize.INTEGER });
     */
  },

  async down (queryInterface, Sequelize) {
    // await queryInterface.addColumn('Users', 'otp', {
    //   type: Sequelize.STRING,
    // });
    await queryInterface.addColumn('Users', 'otpExpires', {
      type: Sequelize.DATE,
    });
    await queryInterface.addColumn('Users', 'isVerified', {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    });
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
  }
};
