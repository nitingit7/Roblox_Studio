# 🌟 Roblox Admin Commands System

A powerful admin command system for Roblox games with ban management, player controls, and moderation tools.

![Admin System Demo](https://via.placeholder.com/800x400.png?text=Admin+Commands+Demo)  
*(Replace with actual screenshot)*

## 🛠️ Features

- 🔒 **Ban/Unban System** with DataStore persistence
- 👮 **Admin Verification** with multiple admin support
- ✈️ **Player Teleportation** commands
- 🚪 **Kick/Ban** with optional reasons
- 🏃 **Speed Control** for players
- 📊 **Player Lookup** utilities

## 📋 Command List

| Command | Description | Usage | Example |
|---------|-------------|-------|---------|
| `/ban [player]` | Ban a player permanently | `/ban [username]` | `/ban ToxicPlayer` |
| `/unban [UserId]` | Unban a player | `/unban ForgivenPlayer` | `/unban GoodPlayer` |
| `/kick [player] [reason]` | Kick a player | `/kick [username] [reason]` | `/kick RuleBreaker Spamming chat` |
| `/tp [player1] [player2]` | Teleport player1 to player2 | `/tp [from] [to]` | `/tp NewPlayer MentorPlayer` |
| `/speed [player] [value]` | Set player walkspeed | `/speed [user] [16-100]` | `/speed Runner 50` |

## 🧑‍💻 Installation

1. **ServerScriptService**  
   Create a new `Script` in `ServerScriptService` with:

```lua
-- Ban system code here
