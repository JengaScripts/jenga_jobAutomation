const Discord = require('discord.js');
const client = new Discord.Client;
const config = require('./config.json');

// It is working only if player is in server. (playing)
// Create Role and add roleId in config.json

if (config.token === '') {
     console.log("Enter Bot Token.");
}
else {
     client.login(config.token)
     client.on('ready', () => {
          console.log(`^1${client.user.username}^2 is ready.^0`)
          exports[GetCurrentResourceName()].SetConfig(config);
     })
     
     client.on('guildMemberUpdate', (oldMember, newMember) => {
          if (oldMember.guild.id === config.guildId && newMember.guild.id === config.guildId) {
               if (!oldMember.roles.equals(newMember.roles)) {
                    const addedRoleIDs = newMember.roles.filter(role => !oldMember.roles.has(role.id)).map(role => role.id);
                    const removedRoleIDs = oldMember.roles.filter(role => !newMember.roles.has(role.id)).map(role => role.id);
        
                    if (addedRoleIDs.length > 0) {
                         addedRoleIDs.forEach(element => {
                              if (config.jobGrades[element.toString()]) {
                                   exports[GetCurrentResourceName()].SetJob(newMember.id, config.jobGrades[element.toString()].job, config.jobGrades[element.toString()].grade);
                              }
                         });
                    }
        
                    if (removedRoleIDs.length > 0) {
                         const myJSON = JSON.stringify(config.jobGrades);
                         removedRoleIDs.forEach(element => {
                              if (myJSON.includes(element.toString())) {
                                   exports[GetCurrentResourceName()].SetJob(newMember.id, defaultJob, defaultGrade);
                              }
                         });
                    }
                }
          }
          
     });
}