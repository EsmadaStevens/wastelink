'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.sequelize.query(`
      ALTER TABLE PickupRequests DROP PRIMARY KEY;
    `);

    // Step 2: Alter `id` to UUID
    await queryInterface.changeColumn('PickupRequests', 'id', {
      type: Sequelize.UUID,
      allowNull: false,
      defaultValue: Sequelize.UUIDV4,
    });

    // Step 3: Add the primary key back to `id`
    await queryInterface.sequelize.query(`
      ALTER TABLE PickupRequests ADD PRIMARY KEY (id);
    `);

    // Step 4: Make collectorId nullable and keep foreign key
    await queryInterface.changeColumn('PickupRequests', 'collectorId', {
      type: Sequelize.UUID,
      allowNull: true,
      references: {
        model: 'Users',
        key: 'id',
      },
      onDelete: 'SET NULL',
      onUpdate: 'CASCADE',
    });
    /**
     * Add altering commands here.
     *
     * Example:
     * await queryInterface.createTable('users', { id: Sequelize.INTEGER });
     */
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.sequelize.query(`
      ALTER TABLE PickupRequests DROP PRIMARY KEY;
    `);

    await queryInterface.changeColumn('PickupRequests', 'id', {
      type: Sequelize.INTEGER,
      allowNull: false,
      autoIncrement: true,
    });

    await queryInterface.sequelize.query(`
      ALTER TABLE PickupRequests ADD PRIMARY KEY (id);
    `);

    // Revert collectorId to non-nullable
    await queryInterface.changeColumn('PickupRequests', 'collectorId', {
      type: Sequelize.INTEGER,
      allowNull: false,
      references: {
        model: 'Users',
        key: 'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    });
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
  }
};
