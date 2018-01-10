--[[                                    
   _____    _        _    _    _____    
  |_   _|__| |__    / \  | | _| ____|   
    | |/ __| '_ \  / _ \ | |/ /  _|     
    | |\__ \ | | |/ ___ \|   <| |___   
    |_||___/_| |_/_/   \_\_|\_\_____|   
              CH > @TshAkETEAM
--]]

serpent = require('serpent')
serp = require 'serpent'.block
http = require("socket.http")
https = require("ssl.https")
http.TIMEOUT = 10
lgi = require ('lgi')
bot=dofile('utils.lua')
json=dofile('json.lua')
JSON = (loadfile  "./libs/dkjson.lua")()
redis = (loadfile "./libs/JSON.lua")()
redis = (loadfile "./libs/redis.lua")()
database = Redis.connect('127.0.0.1', 6379)
notify = lgi.require('Notify')
tdcli = dofile('tdcli.lua')
notify.init ("Telegram updates")
sudos = dofile('sudo.lua')
chats = {}
day = 86400
bot_id_keko = {string.match(token, "^(%d+)(:)(.*)")}
bot_id = tonumber(bot_id_keko[1])
  -----------------------------------------------------------------------------------------------
                                    -- start functions --
  -----------------------------------------------------------------------------------------------
function is_sudo(msg)
  local var = false
  for k,v in pairs(sudo_users) do
  if msg.sender_user_id_ == v then
  var = true
  end
end
  local keko_add_sudo = redis:get('sudoo'..msg.sender_user_id_..''..bot_id)
  if keko_add_sudo then
  var = true
  end
   return var
  end
-----------------------------------------------------------------------------------------------
function is_admin(user_id)
local var = false
  local hashs =  'bot:admins:'
local admin = database:sismember(hashs, user_id)
   if admin then
var = true
   end
  for k,v in pairs(sudo_users) do
if user_id == v then
var = true
end
  end
  local keko_add_sudo = redis:get('sudoo'..user_id..''..bot_id)
  if keko_add_sudo then
  var = true
  end
return var
end


function is_creator(user_id, chat_id)
local var = false
local hash =  'bot:creator:'..chat_id
local creator = database:sismember(hash, user_id)
  local hashs =  'bot:admins:'
local admin = database:sismember(hashs, user_id)
   if creator then
var = true
   end
   if admin then
var = true
   end
for k,v in pairs(sudo_users) do
if user_id == v then
var = true
end
  end
  local keko_add_sudo = redis:get('sudoo'..user_id..''..bot_id)
  if keko_add_sudo then
  var = true
  end
return var
end
-----------------------------------------------------------------------------------------------
function is_vip(user_id, chat_id)
local var = false
	
local hash =  'bot:mods:'..chat_id
local mod = database:sismember(hash, user_id)
	local hashs =  'bot:admins:'
local admin = database:sismember(hashs, user_id)
	local hashss =  'bot:owners:'..chat_id
local owner = database:sismember(hashss, user_id)
	local hashss =  'bot:creator:'..chat_id
local creator = database:sismember(hashss, user_id)
	local hashsss =  'bot:vipgp:'..chat_id
local vip = database:sismember(hashsss, user_id)
	 if mod then
	var = true
	 end
	 if owner then
	var = true
	 end
	 if creator then
	var = true
	 end
	 if admin then
	var = true
	 end
	 if vip then
	var = true
	 end
for k,v in pairs(sudo_users) do
if user_id == v then
var = true
end
	end
  local keko_add_sudo = redis:get('sudoo'..user_id..''..bot_id)
  if keko_add_sudo then
  var = true
  end
return var
end
-----------------------------------------------------------------------------------------------
function is_owner(user_id, chat_id)
local var = false
local hash =  'bot:owners:'..chat_id
local owner = database:sismember(hash, user_id)
  local hashs =  'bot:admins:'
local admin = database:sismember(hashs, user_id)
	local hashss =  'bot:creator:'..chat_id
local creator = database:sismember(hashss, user_id)
   if owner then
var = true
   end
   if admin then
var = true
   end
	 if creator then
	var = true
	 end
for k,v in pairs(sudo_users) do
if user_id == v then
var = true
end
  end
  local keko_add_sudo = redis:get('sudoo'..user_id..''..bot_id)
  if keko_add_sudo then
  var = true
  end
return var
end

-----------------------------------------------------------------------------------------------
function is_mod(user_id, chat_id)
local var = false
local hash =  'bot:mods:'..chat_id
local mod = database:sismember(hash, user_id)
	local hashs =  'bot:admins:'
local admin = database:sismember(hashs, user_id)
	local hashss =  'bot:owners:'..chat_id
local owner = database:sismember(hashss, user_id)
	local hashss =  'bot:creator:'..chat_id
local creator = database:sismember(hashss, user_id)
	 if mod then
	var = true
	 end
	 if owner then
	var = true
	 end
	 if creator then
	var = true
	 end
	 if admin then
	var = true
	 end
for k,v in pairs(sudo_users) do
if user_id == v then
var = true
end
	end
  local keko_add_sudo = redis:get('sudoo'..user_id..''..bot_id)
  if keko_add_sudo then
  var = true
  end
return var
end
-----------------------------------------------------------------------------------------------
function is_banned(user_id, chat_id)
local var = false
	local hash = 'bot:banned:'..chat_id
local banned = database:sismember(hash, user_id)
	 if banned then
	var = true
	 end
return var
end

function is_gbanned(user_id)
  local var = false
  local hash = 'bot:gbanned:'
  local banned = database:sismember(hash, user_id)
  if banned then
var = true
  end
  return var
end

-----------------------------------------------------------------------------------------------
function is_muted(user_id, chat_id)
local var = false
	local hash = 'bot:muted:'..chat_id
local banned = database:sismember(hash, user_id)
	 if banned then
	var = true
	 end
return var
end

function is_gmuted(user_id)
  local var = false
  local hash = 'bot:gmuted:'
  local banned = database:sismember(hash, user_id)
  if banned then
var = true
  end
  return var
end
-----------------------------------------------------------------------------------------------
function get_info(user_id)
  if database:hget('bot:username',user_id) then
text = '@'..(string.gsub(database:hget('bot:username',user_id), 'false', '') or '')..''
  end
  get_user(user_id)
  return text
  --db:hrem('bot:username',user_id)
end
function get_user(user_id)
  function dl_username(arg, data)
username = data.username or ''

--vardump(data)
database:hset('bot:username',data.id_,data.username_)
  end
  tdcli_function ({
ID = "GetUser",
user_id_ = user_id
  }, dl_username, nil)
end
local function getMessage(chat_id, message_id,cb)
  tdcli_function ({
ID = "GetMessage",
chat_id_ = chat_id,
message_id_ = message_id
  }, cb, nil)
end
-----------------------------------------------------------------------------------------------
local function check_filter_words(msg, value)
  local hash = 'bot:filters:'..msg.chat_id_
  if hash then
local names = database:hkeys(hash)
local text = ''
for i=1, #names do
	   if string.match(value:lower(), names[i]:lower()) and not is_vip(msg.sender_user_id_, msg.chat_id_)then
	local id = msg.id_
   local msgs = {[0] = id}
   local chat = msg.chat_id_
  delete_msg(chat,msgs)
 end
end
  end
end
-----------------------------------------------------------------------------------------------
function resolve_username(username,cb)
  tdcli_function ({
ID = "SearchPublicChat",
username_ = username
  }, cb, nil)
end
  -----------------------------------------------------------------------------------------------
function changeChatMemberStatus(chat_id, user_id, status)
  tdcli_function ({
ID = "ChangeChatMemberStatus",
chat_id_ = chat_id,
user_id_ = user_id,
status_ = {
ID = "ChatMemberStatus" .. status
},
  }, dl_cb, nil)
end
  -----------------------------------------------------------------------------------------------
function getInputFile(file)
  if file:match('/') then
infile = {ID = "InputFileLocal", path_ = file}
  elseif file:match('^%d+$') then
infile = {ID = "InputFileId", id_ = file}
  else
infile = {ID = "InputFilePersistentId", persistent_id_ = file}
  end

  return infile
end
os.execute('cd .. &&  rm -fr ../.telegram-cli')
os.execute('cd .. &&  rm -rf ../.telegram-cli')
function del_all_msgs(chat_id, user_id)
  tdcli_function ({
ID = "DeleteMessagesFromUser",
chat_id_ = chat_id,
user_id_ = user_id
  }, dl_cb, nil)
end



  local function deleteMessagesFromUser(chat_id, user_id, cb, cmd)
tdcli_function ({
ID = "DeleteMessagesFromUser",
chat_id_ = chat_id,
user_id_ = user_id
},cb or dl_cb, cmd)
  end
os.execute('cd .. &&  rm -rf .telegram-cli')
os.execute('cd .. &&  rm -fr .telegram-cli')
function getChatId(id)
  local chat = {}
  local id = tostring(id)

  if id:match('^-100') then
local channel_id = id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
  else
local group_id = id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
  end

  return chat
end
  -----------------------------------------------------------------------------------------------
function chat_leave(chat_id, user_id)
  changeChatMemberStatus(chat_id, user_id, "Left")
end
  -----------------------------------------------------------------------------------------------
function from_username(msg)
   function gfrom_user(extra,result,success)
   if result.username_ then
   F = result.username_
   else
   F = 'nil'
   end
return F
   end
  local username = getUser(msg.sender_user_id_,gfrom_user)
  return username
end
  -----------------------------------------------------------------------------------------------
function chat_kick(chat_id, user_id)
  changeChatMemberStatus(chat_id, user_id, "Kicked")
end
  -----------------------------------------------------------------------------------------------
function do_notify (user, msg)
  local n = notify.Notification.new(user, msg)
  n:show ()
end
  -----------------------------------------------------------------------------------------------
local function getParseMode(parse_mode)
  if parse_mode then
local mode = parse_mode:lower()

if mode == 'markdown' or mode == 'md' then
P = {ID = "TextParseModeMarkdown"}
elseif mode == 'html' then
P = {ID = "TextParseModeHTML"}
end
  end
  return P
end

  -----------------------------------------------------------------------------------------------
local function getMessage(chat_id, message_id,cb)
  tdcli_function ({
ID = "GetMessage",
chat_id_ = chat_id,
message_id_ = message_id
  }, cb, nil)
end
-----------------------------------------------------------------------------------------------
function sendContact(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, phone_number, first_name, last_name, user_id)
  tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_to_message_id,
disable_notification_ = disable_notification,
from_background_ = from_background,
reply_markup_ = reply_markup,
input_message_content_ = {
ID = "InputMessageContact",
contact_ = {
  ID = "Contact",
  phone_number_ = phone_number,
  first_name_ = first_name,
  last_name_ = last_name,
  user_id_ = user_id
},
},
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
  tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_to_message_id,
disable_notification_ = disable_notification,
from_background_ = from_background,
reply_markup_ = reply_markup,
input_message_content_ = {
ID = "InputMessagePhoto",
photo_ = getInputFile(photo),
added_sticker_file_ids_ = {},
width_ = 0,
height_ = 0,
caption_ = caption
},
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function getUserFull(user_id,cb)
  tdcli_function ({
ID = "GetUserFull",
user_id_ = user_id
  }, cb, nil)
end
-----------------------------------------------------------------------------------------------
function vardump(value)
  print(serpent.block(value, {comment=false}))
end
-----------------------------------------------------------------------------------------------
function dl_cb(arg, data)
end
-----------------------------------------------------------------------------------------------
local function send(chat_id, reply_to_message_id, disable_notification, text, disable_web_page_preview, parse_mode)
  local TextParseMode = getParseMode(parse_mode)

  tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_to_message_id,
disable_notification_ = disable_notification,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID = "InputMessageText",
text_ = text,
disable_web_page_preview_ = disable_web_page_preview,
clear_draft_ = 0,
entities_ = {},
parse_mode_ = TextParseMode,
},
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function sendaction(chat_id, action, progress)
  tdcli_function ({
ID = "SendChatAction",
chat_id_ = chat_id,
action_ = {
ID = "SendMessage" .. action .. "Action",
progress_ = progress or 100
}
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function changetitle(chat_id, title)
  tdcli_function ({
ID = "ChangeChatTitle",
chat_id_ = chat_id,
title_ = title
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function edit(chat_id, message_id, reply_markup, text, disable_web_page_preview, parse_mode)
  local TextParseMode = getParseMode(parse_mode)
  tdcli_function ({
ID = "EditMessageText",
chat_id_ = chat_id,
message_id_ = message_id,
reply_markup_ = reply_markup,
input_message_content_ = {
ID = "InputMessageText",
text_ = text,
disable_web_page_preview_ = disable_web_page_preview,
clear_draft_ = 0,
entities_ = {},
parse_mode_ = TextParseMode,
},
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function setphoto(chat_id, photo)
  tdcli_function ({
ID = "ChangeChatPhoto",
chat_id_ = chat_id,
photo_ = getInputFile(photo)
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function add_user(chat_id, user_id, forward_limit)
  tdcli_function ({
ID = "AddChatMember",
chat_id_ = chat_id,
user_id_ = user_id,
forward_limit_ = forward_limit or 50
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function delmsg(arg,data)
  for k,v in pairs(data.messages_) do
delete_msg(v.chat_id_,{[0] = v.id_})
  end
end
-----------------------------------------------------------------------------------------------
function unpinmsg(channel_id)
  tdcli_function ({
ID = "UnpinChannelMessage",
channel_id_ = getChatId(channel_id).ID
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
local function blockUser(user_id)
  tdcli_function ({
ID = "BlockUser",
user_id_ = user_id
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
local function unblockUser(user_id)
  tdcli_function ({
ID = "UnblockUser",
user_id_ = user_id
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
local function getBlockedUsers(offset, limit)
  tdcli_function ({
ID = "GetBlockedUsers",
offset_ = offset,
limit_ = limit
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function delete_msg(chatid,mid)
  tdcli_function ({
  ID="DeleteMessages",
  chat_id_=chatid,
  message_ids_=mid
  },
  dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function chat_del_user(chat_id, user_id)
  changeChatMemberStatus(chat_id, user_id, 'Editor')
end
-----------------------------------------------------------------------------------------------
function getChannelMembers(channel_id, offset, filter, limit)
  if not limit or limit > 200 then
limit = 200
  end
  tdcli_function ({
ID = "GetChannelMembers",
channel_id_ = getChatId(channel_id).ID,
filter_ = {
ID = "ChannelMembers" .. filter
},
offset_ = offset,
limit_ = limit
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function getChannelFull(channel_id)
  tdcli_function ({
ID = "GetChannelFull",
channel_id_ = getChatId(channel_id).ID
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
local function channel_get_bots(channel,cb)
local function callback_admins(extra,result,success)
limit = result.member_count_
getChannelMembers(channel, 0, 'Bots', limit,cb)
channel_get_bots(channel,get_bots)
end

  getChannelFull(channel,callback_admins)
end
-----------------------------------------------------------------------------------------------
local function getInputMessageContent(file, filetype, caption)
  if file:match('/') then
infile = {ID = "InputFileLocal", path_ = file}
  elseif file:match('^%d+$') then
infile = {ID = "InputFileId", id_ = file}
  else
infile = {ID = "InputFilePersistentId", persistent_id_ = file}
  end

  local inmsg = {}
  local filetype = filetype:lower()

  if filetype == 'animation' then
inmsg = {ID = "InputMessageAnimation", animation_ = infile, caption_ = caption}
  elseif filetype == 'audio' then
inmsg = {ID = "InputMessageAudio", audio_ = infile, caption_ = caption}
  elseif filetype == 'document' then
inmsg = {ID = "InputMessageDocument", document_ = infile, caption_ = caption}
  elseif filetype == 'photo' then
inmsg = {ID = "InputMessagePhoto", photo_ = infile, caption_ = caption}
  elseif filetype == 'sticker' then
inmsg = {ID = "InputMessageSticker", sticker_ = infile, caption_ = caption}
  elseif filetype == 'video' then
inmsg = {ID = "InputMessageVideo", video_ = infile, caption_ = caption}
  elseif filetype == 'voice' then
inmsg = {ID = "InputMessageVoice", voice_ = infile, caption_ = caption}
  end

  return inmsg
end

-----------------------------------------------------------------------------------------------
function send_file(chat_id, type, file, caption,wtf)
local mame = (wtf or 0)
  tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = mame,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = getInputMessageContent(file, type, caption),
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function getUser(user_id, cb)
  tdcli_function ({
ID = "GetUser",
user_id_ = user_id
  }, cb, nil)
end
-----------------------------------------------------------------------------------------------
function pin(channel_id, message_id, disable_notification)
   tdcli_function ({
ID = "PinChannelMessage",
channel_id_ = getChatId(channel_id).ID,
message_id_ = message_id,
disable_notification_ = disable_notification
   }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function tdcli_update_callback(data)
	-------------------------------------------
  if (data.ID == "UpdateNewMessage") then
local msg = data.message_
if data.message_.content_.photo_ then
local keko = database:get('bot:setphoto'..msg.chat_id_..':'..msg.sender_user_id_)
if keko then
local id_keko = nil
if data.message_.content_.photo_.sizes_[0] then
id_keko = data.message_.content_.photo_.sizes_[0].photo_.persistent_id_
end

if data.message_.content_.photo_.sizes_[1] then
id_keko = data.message_.content_.photo_.sizes_[1].photo_.persistent_id_
end

if data.message_.content_.photo_.sizes_[2] then
id_keko = data.message_.content_.photo_.sizes_[2].photo_.persistent_id_
end

if data.message_.content_.photo_.sizes_[3] then
id_keko = data.message_.content_.photo_.sizes_[3].photo_.persistent_id_
end
tdcli.changeChatPhoto(msg.chat_id_, id_keko)
send(msg.chat_id_, msg.id_, 1, '✔️┇تم وضع صوره للمجموعه️', 1, 'md')
database:del('bot:setphoto'..msg.chat_id_..':'..msg.sender_user_id_)
end
end
local d = data.disable_notification_
local chat = chats[msg.chat_id_]
	-------------------------------------------
	if msg.date_ < (os.time() - 30) then
 return false
end
	-------------------------------------------
	if not database:get("bot:enable:"..msg.chat_id_) and not is_sudo(msg) then
return false
end
-------------------------------------------
if msg and msg.send_state_.ID == "MessageIsSuccessfullySent" then
	  --vardump(msg)
	   function get_mymsg_contact(extra, result, success)
 --vardump(result)
 end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,get_mymsg_contact)
   return false
end
-------------* EXPIRE *-----------------
if not database:get("bot:charge:"..msg.chat_id_) then
if database:get("bot:enable:"..msg.chat_id_) then
database:del("bot:enable:"..msg.chat_id_)
for k,v in pairs(sudo_users) do
end
end
end
--------- ANTI FLOOD -------------------
	local hash = 'flood:max:'..msg.chat_id_
if not database:get(hash) then
  floodMax = 10
else
  floodMax = tonumber(database:get(hash))
end

local hash = 'flood:time:'..msg.chat_id_
if not database:get(hash) then
  floodTime = 1
else
  floodTime = tonumber(database:get(hash))
end
if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  local hashse = 'anti-flood:'..msg.chat_id_
  if not database:get(hashse) then
if not is_vip(msg.sender_user_id_, msg.chat_id_) then
local hash = 'flood:'..msg.sender_user_id_..':'..msg.chat_id_..':msg-num'
local msgs = tonumber(database:get(hash) or 0)
if msgs > (floodMax - 1) then
  local user = msg.sender_user_id_
  local chat = msg.chat_id_
  local channel = msg.chat_id_
		 local user_id = msg.sender_user_id_
		 local banned = is_banned(user_id, msg.chat_id_)
   if banned then
		local id = msg.id_
  local msgs = {[0] = id}
 	local chat = msg.chat_id_
 		 del_all_msgs(msg.chat_id_, msg.sender_user_id_)
		else
		 local id = msg.id_
   local msgs = {[0] = id}
   local chat = msg.chat_id_
		chat_kick(msg.chat_id_, msg.sender_user_id_)
		 del_all_msgs(msg.chat_id_, msg.sender_user_id_)
		user_id = msg.sender_user_id_
		local bhash =  'bot:banned:'..msg.chat_id_
  database:sadd(bhash, user_id)
send(msg.chat_id_, msg.id_, 1, '🎫┇الايدي ~⪼ *('..msg.sender_user_id_..')* \n❕┇قمت بعمل تكرار للرسائل المحدده\n☑┇وتم حظرك من المجموعه\n', 1, 'md')
	  end
end
database:setex(hash, floodTime, msgs+1)
end
  end
	end

	local hash = 'flood:max:warn'..msg.chat_id_
if not database:get(hash) then
  floodMax = 10
else
  floodMax = tonumber(database:get(hash))
end

local hash = 'flood:time:'..msg.chat_id_
if not database:get(hash) then
  floodTime = 1
else
  floodTime = tonumber(database:get(hash))
end
if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  local hashse = 'anti-flood:warn'..msg.chat_id_
  if not database:get(hashse) then
if not is_vip(msg.sender_user_id_, msg.chat_id_) then
local hash = 'flood:'..msg.sender_user_id_..':'..msg.chat_id_..':msg-num'
local msgs = tonumber(database:get(hash) or 0)
if msgs > (floodMax - 1) then
  local user = msg.sender_user_id_
  local chat = msg.chat_id_
  local channel = msg.chat_id_
		 local user_id = msg.sender_user_id_
		 local banned = is_banned(user_id, msg.chat_id_)
   if banned then
		local id = msg.id_
  local msgs = {[0] = id}
 	local chat = msg.chat_id_
 		 del_all_msgs(msg.chat_id_, msg.sender_user_id_)
		else
		 local id = msg.id_
   local msgs = {[0] = id}
   local chat = msg.chat_id_
		 del_all_msgs(msg.chat_id_, msg.sender_user_id_)
		user_id = msg.sender_user_id_
		local bhash =  'bot:muted:'..msg.chat_id_
  database:sadd(bhash, user_id)
send(msg.chat_id_, msg.id_, 1, '🎫┇الايدي ~⪼*('..msg.sender_user_id_..')* \n❕┇قمت بعمل تكرار للرسائل المحدده\n☑┇وتم كتم من المجموعه\n', 1, 'md')
	  end
end
database:setex(hash, floodTime, msgs+1)
end
  end
	end

	local hash = 'flood:max:del'..msg.chat_id_
if not database:get(hash) then
  floodMax = 10
else
  floodMax = tonumber(database:get(hash))
end

local hash = 'flood:time:'..msg.chat_id_
if not database:get(hash) then
  floodTime = 1
else
  floodTime = tonumber(database:get(hash))
end
if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  local hashse = 'anti-flood:del'..msg.chat_id_
  if not database:get(hashse) then
if not is_vip(msg.sender_user_id_, msg.chat_id_) then
local hash = 'flood:'..msg.sender_user_id_..':'..msg.chat_id_..':msg-num'
local msgs = tonumber(database:get(hash) or 0)
if msgs > (floodMax - 1) then
  local user = msg.sender_user_id_
  local chat = msg.chat_id_
  local channel = msg.chat_id_
		 local user_id = msg.sender_user_id_
		 local banned = is_banned(user_id, msg.chat_id_)
   if banned then
		local id = msg.id_
  local msgs = {[0] = id}
 	local chat = msg.chat_id_
 		 del_all_msgs(msg.chat_id_, msg.sender_user_id_)
		else
		 local id = msg.id_
   local msgs = {[0] = id}
   local chat = msg.chat_id_
		 del_all_msgs(msg.chat_id_, msg.sender_user_id_)
		user_id = msg.sender_user_id_
send(msg.chat_id_, msg.id_, 1, '🎫┇الايدي ~⪼*('..msg.sender_user_id_..')* \n❕┇قمت بعمل تكرار للرسائل المحدده\n☑┇وتم مسح كل رسائلك المجموعه\n', 1, 'md')
	  end
end
database:setex(hash, floodTime, msgs+1)
end
  end
	end
	-------------------------------------------
database:incr("bot:allmsgs")
  if msg.chat_id_ then
  local id = tostring(msg.chat_id_)
  if id:match('-100(%d+)') then
  if not database:sismember("bot:groups",msg.chat_id_) then
  database:sadd("bot:groups",msg.chat_id_)
  end
  elseif id:match('^(%d+)') then
  if not database:sismember("bot:userss",msg.chat_id_) then
  database:sadd("bot:userss"..bot_id,msg.chat_id_)
  end
  else
  if not database:sismember("bot:groups",msg.chat_id_) then
  database:sadd("bot:groups",msg.chat_id_)
  end
 end
end
	-------------------------------------------
-------------* MSG TYPES *-----------------
   if msg.content_ then
   	if msg.reply_markup_ and  msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" then
		print("Send INLINE KEYBOARD")
	msg_type = 'MSG:Inline'
	-------------------------
elseif msg.content_.ID == "MessageText" then
	text = msg.content_.text_
		print("SEND TEXT")
	msg_type = 'MSG:Text'
	-------------------------
	elseif msg.content_.ID == "MessagePhoto" then
	print("SEND PHOTO")
	if msg.content_.caption_ then
	caption_text = msg.content_.caption_
	end
	msg_type = 'MSG:Photo'
	-------------------------
	elseif msg.content_.ID == "MessageChatAddMembers" then
	print("NEW ADD TO GROUP")
	msg_type = 'MSG:NewUserAdd'
	-------------------------
	elseif msg.content_.ID == "MessageChatJoinByLink" then
		print("JOIN TO GROUP")
	msg_type = 'MSG:NewUserLink'
	-------------------------
	elseif msg.content_.ID == "MessageSticker" then
		print("SEND STICKER")
	msg_type = 'MSG:Sticker'
	-------------------------
	elseif msg.content_.ID == "MessageAudio" then
		print("SEND MUSIC")
	if msg.content_.caption_ then
	caption_text = msg.content_.caption_
	end
	msg_type = 'MSG:Audio'
	-------------------------
	elseif msg.content_.ID == "MessageVoice" then
		print("SEND VOICE")
	if msg.content_.caption_ then
	caption_text = msg.content_.caption_
	end
	msg_type = 'MSG:Voice'
	-------------------------
	elseif msg.content_.ID == "MessageVideo" then
		print("SEND VIDEO")
	if msg.content_.caption_ then
	caption_text = msg.content_.caption_
	end
	msg_type = 'MSG:Video'
	-------------------------
	elseif msg.content_.ID == "MessageAnimation" then
		print("SEND GIF")
	if msg.content_.caption_ then
	caption_text = msg.content_.caption_
	end
	msg_type = 'MSG:Gif'
	-------------------------
	elseif msg.content_.ID == "MessageLocation" then
		print("SEND LOCATION")
	if msg.content_.caption_ then
	caption_text = msg.content_.caption_
	end
	msg_type = 'MSG:Location'
	-------------------------
	elseif msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" then
	msg_type = 'MSG:NewUser'
	-------------------------
	elseif msg.content_.ID == "MessageContact" then
		print("SEND CONTACT")
	if msg.content_.caption_ then
	caption_text = msg.content_.caption_
	end
	msg_type = 'MSG:Contact'
	-------------------------
	end
   end
-------------------------------------------
-------------------------------------------
if ((not d) and chat) then
if msg.content_.ID == "MessageText" then
  do_notify (chat.title_, msg.content_.text_)
else
  do_notify (chat.title_, msg.content_.ID)
end
end
  -----------------------------------------------------------------------------------------------
-- end functions --
  -----------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------
-- start code --
  -----------------------------------------------------------------------------------------------
  -------------------------------------- Process mod --------------------------------------------
  -----------------------------------------------------------------------------------------------

  -------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------
  --------------------------******** START MSG CHECKS ********-------------------------------------------
  -------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------
if is_banned(msg.sender_user_id_, msg.chat_id_) then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
		  chat_kick(msg.chat_id_, msg.sender_user_id_)
delete_msg(chat,msgs)
		  return
end

if is_gbanned(msg.sender_user_id_, msg.chat_id_) then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
		  chat_kick(msg.chat_id_, msg.sender_user_id_)
delete_msg(chat,msgs)
		  return
end

if is_gmuted(msg.sender_user_id_, msg.chat_id_) then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
delete_msg(chat,msgs)
		  return
end


if is_muted(msg.sender_user_id_, msg.chat_id_) then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  local user_id = msg.sender_user_id_
delete_msg(chat,msgs)
		  return
end
if database:get('bot:muteall'..msg.chat_id_) and not is_vip(msg.sender_user_id_, msg.chat_id_) then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
  return
end

if database:get('bot:muteallwarn'..msg.chat_id_) and not is_vip(msg.sender_user_id_, msg.chat_id_) then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼("..msg.sender_user_id_..") \n❕┇الوسائط تم قفلها ممنوع ارسالها", 1, 'html')
  return
end

if database:get('bot:muteallban'..msg.chat_id_) and not is_vip(msg.sender_user_id_, msg.chat_id_) then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
 chat_kick(msg.chat_id_, msg.sender_user_id_)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..") \n❕┇الوسائط تم قفلها ممنوع ارسالها\n☑┇تم طردك من المجموعه", 1, 'html')
  return
end
database:incr('user:msgs'..msg.chat_id_..':'..msg.sender_user_id_)
	database:incr('group:msgs'..msg.chat_id_)
if msg.content_.ID == "MessagePinMessage" then
  if database:get('pinnedmsg'..msg.chat_id_) and database:get('bot:pin:mute'..msg.chat_id_) then
   unpinmsg(msg.chat_id_)
   local pin_id = database:get('pinnedmsg'..msg.chat_id_)
   pin(msg.chat_id_,pin_id,0)
   end
end
database:incr('user:msgs'..msg.chat_id_..':'..msg.sender_user_id_)
	database:incr('group:msgs'..msg.chat_id_)
if msg.content_.ID == "MessagePinMessage" then
  if database:get('pinnedmsg'..msg.chat_id_) and database:get('bot:pin:warn'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..") \n📌┇المعرف ~⪼ ("..get_info(msg.sender_user_id_)..")\n❕┇التثبيت مقفول لا تستطيع التثبيت حاليا️\n", 1, 'md')
   unpinmsg(msg.chat_id_)
   local pin_id = database:get('pinnedmsg'..msg.chat_id_)
   pin(msg.chat_id_,pin_id,0)
   end
end
if database:get('bot:viewget'..msg.sender_user_id_) then
if not msg.forward_info_ then
		send(msg.chat_id_, msg.id_, 1, '❕┇قم بارسال المنشور من القناة️\n', 1, 'md')
		database:del('bot:viewget'..msg.sender_user_id_)
	else
		send(msg.chat_id_, msg.id_, 1, '📊┇عدد المشاهدات ~⪼ <b>('..msg.views_..')</b> ', 1, 'html')
  database:del('bot:viewget'..msg.sender_user_id_)
	end
end
if msg_type == 'MSG:Photo' then
 if not is_vip(msg.sender_user_id_, msg.chat_id_) then
     if database:get('bot:photo:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
        if msg.content_.caption_ then
          check_filter_words(msg, msg.content_.caption_)
          if database:get('bot:links:mute'..msg.chat_id_) then
	if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") or msg.content_.caption_:match("@") or msg.content_.caption_:match("#")  then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
        end
        end
        if msg.forward_info_ then
          if database:get('bot:forward:mute'..msg.chat_id_) then
            if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
          end
      end
       if database:get('bot:photo:ban'..msg.chat_id_) then
           local id = msg.id_
           local msgs = {[0] = id}
           local chat = msg.chat_id_
           local user_id = msg.sender_user_id_
              delete_msg(chat,msgs)
       		   chat_kick(msg.chat_id_, msg.sender_user_id_)
                 send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..") \n❕┇الصور تم قفلها ممنوع ارسالها\n☑┇تم طردك من المجموعه", 1, 'html')

                 return
          end
               if database:get('bot:photo:warn'..msg.chat_id_) then
                   local id = msg.id_
                   local msgs = {[0] = id}
                   local chat = msg.chat_id_
                   local user_id = msg.sender_user_id_
                      delete_msg(chat,msgs)
                          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..") \n❕┇الصور تم قفلها ممنوع ارسالها", 1, 'html')
                         return
           end
end
   elseif msg.content_.ID == 'MessageDocument' then
   if not is_vip(msg.sender_user_id_, msg.chat_id_) then
    if database:get('bot:document:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
         if msg.content_.caption_ then
           check_filter_words(msg, msg.content_.caption_)
           if database:get('bot:links:mute'..msg.chat_id_) then
 	if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") or msg.content_.caption_:match("@") or msg.content_.caption_:match("#")  then
               local id = msg.id_
               local msgs = {[0] = id}
               local chat = msg.chat_id_
               delete_msg(chat,msgs)
             end
         end
         end
        if msg.forward_info_ then
          if database:get('bot:forward:mute'..msg.chat_id_) then
            if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
          end
      end
        if database:get('bot:document:ban'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
       chat_kick(msg.chat_id_, msg.sender_user_id_)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الملفات تم قفلها ممنوع ارسالها\n🚷┇تم طردك من المجموعه", 1, 'html')
          return
   end

        if database:get('bot:document:warn'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الملفات تم قفلها ممنوع ارسالها", 1, 'html')
          return
   end
   end
  elseif msg_type == 'MSG:Inline' then
   if not is_vip(msg.sender_user_id_, msg.chat_id_) then
    if database:get('bot:inline:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
        if msg.forward_info_ then
          if database:get('bot:forward:mute'..msg.chat_id_) then
            if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
          end
        end
        if database:get('bot:inline:ban'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
       chat_kick(msg.chat_id_, msg.sender_user_id_)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الانلاين تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
          return
   end

        if database:get('bot:inline:warn'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الانلاين تم قفلها ممنوع ارسالها", 1, 'html')
          return
   end
   end
  elseif msg_type == 'MSG:Sticker' then
   if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:sticker:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
        if msg.forward_info_ then
          if database:get('bot:forward:mute'..msg.chat_id_) then
            if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
          end
        end
        if database:get('bot:sticker:ban'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
       chat_kick(msg.chat_id_, msg.sender_user_id_)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الملصقات تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
          return
   end

        if database:get('bot:sticker:warn'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
    send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الملصقات تم قفلها ممنوع ارسالها", 1, 'html')
          return
   end
   end
elseif msg_type == 'MSG:NewUserLink' then
  if database:get('bot:tgservice:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
   function get_welcome(extra,result,success)
    if database:get('welcome:'..msg.chat_id_) then
        text = database:get('welcome:'..msg.chat_id_)
    else
        text = 'Hi {firstname} 😃'
    end
    local text = text:gsub('{firstname}',(result.first_name_ or ''))
    local text = text:gsub('{lastname}',(result.last_name_ or ''))
    local text = text:gsub('{username}',(result.username_ or ''))
         send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
   end
	  if database:get("bot:welcome"..msg.chat_id_) then
        getUser(msg.sender_user_id_,get_welcome)
      end
elseif msg_type == 'MSG:NewUserAdd' then
  if database:get('bot:tgservice:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
      --vardump(msg)
if msg.content_.ID == "MessageChatAddMembers" then
            if msg.content_.members_[0].type_.ID == 'UserTypeBot' then
      if database:get('bot:bots:mute'..msg.chat_id_) and not is_mod(msg.content_.members_[0].id_, msg.chat_id_) then
     chat_kick(msg.chat_id_, msg.content_.members_[0].id_)
     return false
    end
 end
 end
   if is_banned(msg.content_.members_[0].id_, msg.chat_id_) then
		 chat_kick(msg.chat_id_, msg.content_.members_[0].id_)
		 return false
   end

       if msg.content_.ID == "MessageChatAddMembers" then
            if msg.content_.members_[0].type_.ID == 'UserTypeBot' then
      if database:get('bot:bots:ban'..msg.chat_id_) and not is_mod(msg.content_.members_[0].id_, msg.chat_id_) then
		 chat_kick(msg.chat_id_, msg.content_.members_[0].id_)
		 chat_kick(msg.chat_id_, msg.sender_user_id_)
         send(msg.chat_id_, msg.id_, 1, "☑┇تم طرد البوت ~⪼ (<code>"..msg.content_.members_[0].id_.."</code>)\n👤┇العضو ~⪼ (<code>"..msg.sender_user_id.."</code>)\n❕┇بسبب اضافه البوتات", 1, 'html')
		 return false
	  end
 end
 end

elseif msg_type == 'MSG:Contact' then
 if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:contact:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
        if msg.forward_info_ then
          if database:get('bot:forward:mute'..msg.chat_id_) then
            if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
          end
        end
        if database:get('bot:contact:ban'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
       chat_kick(msg.chat_id_, msg.sender_user_id_)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇جهات الاتصال تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
          return
   end

        if database:get('bot:contact:warn'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
        send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ جهات الاتصال تم قفلها ممنوع ارسالها", 1, 'html')
          return
   end
   end
elseif msg_type == 'MSG:Audio' then
 if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:music:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
          if msg.content_.caption_ then
            check_filter_words(msg, msg.content_.caption_)
            if database:get('bot:links:mute'..msg.chat_id_) then
  	if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") or msg.content_.caption_:match("@") or msg.content_.caption_:match("#")  then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
              end
          end
          end
        if msg.forward_info_ then
          if database:get('bot:forward:mute'..msg.chat_id_) then
            if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
          end
        end
        if database:get('bot:music:ban'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
       chat_kick(msg.chat_id_, msg.sender_user_id_)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الاغاني تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
          return
   end

        if database:get('bot:music:warn'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الاغاني تم قفلها ممنوع ارسالها", 1, 'html')
          return
   end
   end
elseif msg_type == 'MSG:Voice' then
 if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:voice:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
           if msg.content_.caption_ then
             check_filter_words(msg, msg.content_.caption_)
             if database:get('bot:links:mute'..msg.chat_id_) then
   	if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") or msg.content_.caption_:match("@") or msg.content_.caption_:match("#")  then
                 local id = msg.id_
                 local msgs = {[0] = id}
                 local chat = msg.chat_id_
                 delete_msg(chat,msgs)
               end
           end
           end
        if msg.forward_info_ then
          if database:get('bot:forward:mute'..msg.chat_id_) then
            if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
          end
        end
        if database:get('bot:voice:ban'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
       chat_kick(msg.chat_id_, msg.sender_user_id_)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الصوتيات تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
          return
   end

        if database:get('bot:voice:warn'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
         send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الصوتيات تم قفلها ممنوع ارسالها", 1, 'html')
          return
   end
   end
elseif msg_type == 'MSG:Location' then
 if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:location:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
        if msg.forward_info_ then
          if database:get('bot:forward:mute'..msg.chat_id_) then
            if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
          end
        end
        if database:get('bot:location:ban'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
       chat_kick(msg.chat_id_, msg.sender_user_id_)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الشبكات تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
          return
   end

        if database:get('bot:location:warn'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الشبكات تم قفلها ممنوع ارسالها", 1, 'html')
          return
   end
   end
elseif msg_type == 'MSG:Video' then
 if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:video:mute'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
         if msg.content_.caption_ then
           check_filter_words(msg, msg.content_.caption_)
           if database:get('bot:links:mute'..msg.chat_id_) then
 	if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") or msg.content_.caption_:match("@") or msg.content_.caption_:match("#")  then
               local id = msg.id_
               local msgs = {[0] = id}
               local chat = msg.chat_id_
               delete_msg(chat,msgs)
             end
         end
         end
        if msg.forward_info_ then
          if database:get('bot:forward:mute'..msg.chat_id_) then
            if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
          end
        end
        if database:get('bot:video:ban'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
       chat_kick(msg.chat_id_, msg.sender_user_id_)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الفيديوهات تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
          return
   end

        if database:get('bot:video:warn'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الفيديوهات تم قفلها ممنوع ارسالها", 1, 'html')
          return
   end
   end
elseif msg_type == 'MSG:Gif' then
 if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:gifs:mute'..msg.chat_id_) and not is_vip(msg.sender_user_id_, msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
       delete_msg(chat,msgs)
          return
   end
         if msg.content_.caption_ then
           check_filter_words(msg, msg.content_.caption_)
           if database:get('bot:links:mute'..msg.chat_id_) then
 	if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") or msg.content_.caption_:match("@") or msg.content_.caption_:match("#")  then
               local id = msg.id_
               local msgs = {[0] = id}
               local chat = msg.chat_id_
               delete_msg(chat,msgs)
             end
         end
         end
        if msg.forward_info_ then
          if database:get('bot:forward:mute'..msg.chat_id_) then
            if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
            end
          end
        end
        if database:get('bot:gifs:ban'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
       chat_kick(msg.chat_id_, msg.sender_user_id_)
     send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الصور المتحركه تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
          return
   end

        if database:get('bot:gifs:warn'..msg.chat_id_) then
    local id = msg.id_
    local msgs = {[0] = id}
    local chat = msg.chat_id_
    local user_id = msg.sender_user_id_
       delete_msg(chat,msgs)
          send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الصور المتحركه تم قفلها ممنوع ارسالها", 1, 'html')
          return
   end
   end
elseif msg_type == 'MSG:Text' then
 --vardump(msg)
if database:get("bot:group:link"..msg.chat_id_) == 'Waiting For Link!\nPls Send Group Link' and is_mod(msg.sender_user_id_, msg.chat_id_) then if text:match("(https://telegram.me/joinchat/%S+)") or text:match("(https://t.me/joinchat/%S+)") then 	 local glink = text:match("(https://telegram.me/joinchat/%S+)") or text:match("(https://t.me/joinchat/%S+)") local hash = "bot:group:link"..msg.chat_id_ database:set(hash,glink) 			 send(msg.chat_id_, msg.id_, 1, '☑┇تم وضع رابط', 1, 'md') send(msg.chat_id_, 0, 1, '↙️┇رابط المجموعه الجديد\n'..glink, 1, 'html')
end
   end
function check_username(extra,result,success)
	 --vardump(result)
	local username = (result.username_ or '')
	local svuser = 'user:'..result.id_
	if username then
database:hset(svuser, 'username', username)
end
	if username and username:match("[Bb][Oo][Tt]$") then
if database:get('bot:bots:mute'..msg.chat_id_) and not is_mod(result.id_, msg.chat_id_) then
		 return false
		 end
	  end
   end
getUser(msg.sender_user_id_,check_username)
   database:set('bot:editid'.. msg.id_,msg.content_.text_)
   if not is_vip(msg.sender_user_id_, msg.chat_id_) then
check_filter_words(msg, text)
	if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or
text:match("[Tt].[Mm][Ee]") or
text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or
text:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") then
if database:get('bot:links:mute'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
	end

  if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
end
end
  end
 if database:get('bot:links:ban'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  local user_id = msg.sender_user_id_
  delete_msg(chat,msgs)
chat_kick(msg.chat_id_, msg.sender_user_id_)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الروابط تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
  end
 if database:get('bot:links:warn'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  local user_id = msg.sender_user_id_
  delete_msg(chat,msgs)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الروابط تم قفلها ممنوع ارسالها", 1, 'html')
	end
 end

if text then
  local _nl, ctrl_chars = string.gsub(text, '%c', '')
  local _nl, real_digits = string.gsub(text, '%d', '')
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  local hash = 'bot:sens:spam'..msg.chat_id_
  if not database:get(hash) then
sens = 300
  else
sens = tonumber(database:get(hash))
  end
  if database:get('bot:spam:mute'..msg.chat_id_) and string.len(text) > (sens) or ctrl_chars > (sens) or real_digits > (sens) then
delete_msg(chat,msgs)
  end
end

if text then
  local _nl, ctrl_chars = string.gsub(text, '%c', '')
  local _nl, real_digits = string.gsub(text, '%d', '')
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  local hash = 'bot:sens:spam:warn'..msg.chat_id_
  if not database:get(hash) then
sens = 300
  else
sens = tonumber(database:get(hash))
  end
  if database:get('bot:spam:warn'..msg.chat_id_) and string.len(text) > (sens) or ctrl_chars > (sens) or real_digits > (sens) then
delete_msg(chat,msgs)
  send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الكلايش تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
  end
end

	if text then
if database:get('bot:text:mute'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
	end
  if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
end
end
  end
  if database:get('bot:text:ban'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
 chat_kick(msg.chat_id_, msg.sender_user_id_)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الدردشه تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
return
   end

  if database:get('bot:text:warn'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الدردشه تم قفلها ممنوع ارسالها", 1, 'html')
return
   end
if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
	if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
	end
   end
end
end
if msg.forward_info_ then
if database:get('bot:forward:ban'..msg.chat_id_) then
	if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  local user_id = msg.sender_user_id_
  delete_msg(chat,msgs)
		chat_kick(msg.chat_id_, msg.sender_user_id_)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇التوجيه تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
	end
   end

if msg.forward_info_ then
if database:get('bot:forward:warn'..msg.chat_id_) then
	if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  local user_id = msg.sender_user_id_
  delete_msg(chat,msgs)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ التوجيه تم قفلها ممنوع ارسالها", 1, 'html')
	end
   end
end
elseif msg_type == 'MSG:Text' then
   if text:match("@") or msg.content_.entities_[0] and msg.content_.entities_[0].ID == "MessageEntityMentionName" then
   if database:get('bot:tag:mute'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
	end
  if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
end
end
  end
  if database:get('bot:tag:ban'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
 chat_kick(msg.chat_id_, msg.sender_user_id_)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇المعرفات تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
return
   end

  if database:get('bot:tag:warn'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ المعرفات تم قفلها ممنوع ارسالها", 1, 'html')
return
   end
 end
   	if text:match("#") then
if database:get('bot:hashtag:mute'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
	end
  if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
end
end
  end
  if database:get('bot:hashtag:ban'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
 chat_kick(msg.chat_id_, msg.sender_user_id_)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇التاكات تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
return
   end

  if database:get('bot:hashtag:warn'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ التاكات تم قفلها ممنوع ارسالها", 1, 'html')
return
   end
end

   	if text:match("/") then
if database:get('bot:cmd:mute'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
	end
  if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
end
end
  end
if database:get('bot:cmd:ban'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  local user_id = msg.sender_user_id_
  delete_msg(chat,msgs)
 chat_kick(msg.chat_id_, msg.sender_user_id_)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الشارحه تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
	end
	if database:get('bot:cmd:warn'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  local user_id = msg.sender_user_id_
  delete_msg(chat,msgs)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ الشارحه تم قفلها ممنوع ارسالها", 1, 'html')
	end
	end
   	if text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://") or text:match(".[Ii][Rr]") or text:match(".[Cc][Oo][Mm]") or text:match(".[Oo][Rr][Gg]") or text:match(".[Ii][Nn][Ff][Oo]") or text:match("[Ww][Ww][Ww].") or text:match(".[Tt][Kk]") then
if database:get('bot:webpage:mute'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
	end
  if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
end
end
  end
  if database:get('bot:webpage:ban'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
 chat_kick(msg.chat_id_, msg.sender_user_id_)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇المواقع تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
return
   end

  if database:get('bot:webpage:warn'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ المواقع تم قفلها ممنوع ارسالها", 1, 'html')
return
   end
 end
   	if text:match("[\216-\219][\128-\191]") then
if database:get('bot:arabic:mute'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
	end
  if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
end
end
  end
  if database:get('bot:arabic:ban'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
 chat_kick(msg.chat_id_, msg.sender_user_id_)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇اللغه العربيه تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
return
   end

  if database:get('bot:arabic:warn'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ اللغه العربيه تم قفلها ممنوع ارسالها", 1, 'html')
return
   end
 end
   	  if text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
if database:get('bot:english:mute'..msg.chat_id_) then
local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
	  end
  if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
  local id = msg.id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
end
end
  end
	if database:get('bot:english:ban'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
 chat_kick(msg.chat_id_, msg.sender_user_id_)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇اللغه الانكليزيه تم قفلها ممنوع ارسالها ️\n🚷┇تم طردك من المجموعه", 1, 'html')
return
   end

  if database:get('bot:english:warn'..msg.chat_id_) then
local id = msg.id_
local msgs = {[0] = id}
local chat = msg.chat_id_
local user_id = msg.sender_user_id_
 delete_msg(chat,msgs)
send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇ اللغه الانكليزيه تم قفلها ممنوع ارسالها", 1, 'html')
return
   end
end
end
   end
  if database:get('bot:cmds'..msg.chat_id_) and not is_vip(msg.sender_user_id_, msg.chat_id_) then
  return
else

if text == 'هلو' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• هَٰہۧـﮧﮧلْٰاَٰوٍّ໑اَٰتّٰ 🌝☄ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end

if text == 'تشاكي' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• نٍٰـعٍِّـﮧﮧمٍٰ تّٰفِٰـہضلْٰ 🍁🌛ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'شلونكم' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• تّٰمٍٰـﮧاَٰمٍٰ وٍّاَٰنٍٰتّٰـہهَٰہۧ 😽⚡️ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'شلونك' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• اَٰلْٰـحٌٰمٍٰـﮧﮧدِٰاَٰلْٰلْٰهَٰہۧ وٍّ୭اَٰنٍٰتّٰـهَٰہۧ 😼💛ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'تمام' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• دِٰوٍّ൭مٍٰ يَٰـﮧﮧاَٰرِٰبٌِٰ 😻🌪ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'هلاو' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• هَٰہۧـہ୪وٍّ୭اَٰتّٰ حٌٰبٌِٰـﮧيَٰ 🤗🌟ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😐' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• شَُـبٌِٰيَٰـكٍٰ صُِـﮧﮧاَٰفِٰنٍٰ عٍِّ خّٰاَٰلْٰتّٰـہكٍٰ😹🖤ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'هاي' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• هَٰہۧـاَٰيَٰـﮧﮧاَٰتّٰ يَٰـرِٰوٍّحٌٰـہيَٰ 🙋🏼‍♂💙ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'بوت' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• تّٰفِٰـضـﮧلْٰ حٌٰبٌِٰـہيَٰ 🌚💫ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'اريد اكبل' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• شَُـوٍّ໑فِٰلْٰيَٰ وٍّيَٰـاَٰكٍٰ حٌٰدِٰيَٰـہقٍٰهَٰہۧ وٍّدِٰاَٰيَٰـﮧحٌٰ رِٰسٌٍمٍٰـہيَٰ😾😹💜ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'لتزحف' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• دِٰعٍِّـوٍّ໑فِٰهَٰہۧ زًَاَٰحٌٰـﮧفِٰ عٍِّ خّٰاَٰلْٰـتّٰكٍٰ خّٰـلْٰيَٰ يَٰسٌٍـہتّٰفِٰاَٰدِٰ😾🌈ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'كلخرا' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• خّٰـﮧرِٰاَٰ يَٰتّٰـہرِٰسٌٍ حٌٰلْٰكٍٰـﮧكٍٰ يَٰاَٰخّٰـﮧرِٰاَٰاَٰ💩ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'زاحف' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• زًَاَٰحٌٰـﮧفِٰ عٍِّ اَٰخّٰتّٰـﮧكٍٰ؟ كٍٰضيَٰـﮧتّٰ عٍِّمٍٰرِٰكٍٰ جًِّرِٰجًِّـﮧفِٰ😾😹ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'دي' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• خّٰلْٰيَٰنٍٰـﮧيَٰ اَٰحٌٰبٌِٰـﮧكٍٰ 😾ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'فرخ' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• وٍّيَٰنٍٰـﮧهَٰہۧ؟ خّٰ اَٰحٌٰضـﮧرِٰهَٰہۧ 😾😹ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'تعالي خاص' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• اَٰهَٰہۧـﮧوٍّ໑ ضـﮧلْٰ ضـﮧلْٰ سٌٍـﮧاَٰحٌٰفِٰ كٍٰبٌِٰـﮧرِٰ طَُِمٍٰـہكٍٰ😗😂💚ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'اكرهك' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "•دِٰيَٰلْٰـﮧهَٰہۧ شَُـﮧوٍّ୭نٍٰ اَٰطَُِيَٰـقٍٰكٍٰ نٍٰـيَٰ 🙎🏼‍♂🖤ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'احبك' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "•حٌٰبٌِٰيَٰبٌِٰـﮧيَٰ وٍّنٍٰـﮧيَٰ هَٰہۧــمٍٰ😻👅ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'باي' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• وٍّيَٰـﮧنٍٰ رِٰاَٰيَٰـہحٌٰ خّٰلْٰيَٰنٍٰـﮧهَٰہۧ مٍٰتّٰوٍّنٍٰسٌٍيَٰـﮧنٍٰ🙁💔ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'واكف' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• بٌِٰنٍٰلْٰخّٰـﮧرِٰاَٰ وٍّيَٰـﮧنٍٰ وٍّاَٰكٍٰـﮧفِٰ😐😒ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'وين المدير' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• لْٰيَٰـﮧشَُ شَُتّٰـﮧرِٰيَٰدِٰ🤔ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'انجب' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• صُِـﮧاَٰرِٰ سٌٍتّٰـﮧاَٰدِٰيَٰ🐸❤️ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'تحبني' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• مٍٰـﮧاَٰدِٰرِٰيَٰ اَٰفِٰكٍٰـﮧرِٰ🙁😹ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🌚' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• فِٰـﮧدِٰيَٰتّٰ صُِخّٰـﮧاَٰمٍٰكٍٰ🙊👄ֆ "
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🙄' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• نٍٰـہزًَلْٰ عٍِّيَٰـنٍٰكٍٰ عٍِّيَٰـﮧبٌِٰ🌚😹ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😒' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• شَُبٌِٰيَٰـﮧكٍٰ كٍٰاَٰلْٰـﮧبٌِٰ خّٰلْٰقٍٰتّٰـﮧكٍٰ😟🐈ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😳' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• هَٰہۧـاَٰ بٌِٰسٌٍ لْٰاَٰ شَُفِٰـﮧتّٰ عٍِّمٍٰتّٰـﮧكٍٰ اَٰلْٰعٍِّـﮧوٍّ໑بٌِٰهَٰہۧ😐😹ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🙁' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• تّٰعٍِّـﮧاَٰلْٰ اَٰشَُكٍٰيَٰلْٰـﮧيَٰ هَٰہۧمٍٰوٍّمٍٰـﮧكٍٰ لْٰيَٰـشَُ • ضاَٰيَٰـﮧجًِّ🙁💔ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🚶💔' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• تّٰعٍِّـﮧاَٰلْٰ اَٰشَُكٍٰيَٰلْٰـﮧيَٰ هَٰہۧمٍٰوٍّمٍٰـﮧكٍٰ لْٰيَٰـشَُ • ضاَٰيَٰـﮧجًِّ🙁💔ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🙂' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• ثِْْكٍٰيَٰـﮧلْٰ نٍٰهَٰہۧنٍٰهَٰہۧنٍٰهَٰہۧنٍٰهَٰہۧ🐛ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🌝' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• مٍٰنٍٰـﮧوٍّ໑رِٰ حٌٰبٌِٰـعٍِّمٍٰـہرِٰيَٰ😽💚ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'صباحو' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• صُِبٌِٰاَٰحٌٰـہكٍٰ عٍِّسٌٍـہلْٰ يَٰعٍِّسٌٍـﮧلْٰ😼🤞ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'صباح الخير' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• صُِبٌِٰاَٰحٌٰـہكٍٰ عٍِّسٌٍـہلْٰ يَٰعٍِّسٌٍـﮧلْٰ😼🤞ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'كفو' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• اَٰهَٰہۧ كٍٰفِٰـﮧوٍّ໑ يَٰبٌِٰہوٍّ୭ اَٰلْٰضـلْٰہوٍّ୭عٍِّ😹ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😌' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• اَٰلْٰمٍٰطَُِلْٰـﮧوٍّ໑بٌِٰ !😕💞ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'اها' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• يَٰبٌِٰ قٍٰاَٰبٌِٰـﮧلْٰ اَٰغِِٰشَُـﮧكٍٰ شَُسٌٍاَٰلْٰفِٰـﮧهَٰہۧ حٌٰبٌِٰ😐🌝ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'شسمج' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• اَٰسٌٍـمٍٰهَٰہۧـﮧاَٰ جًِّعٍِّجًِّـﮧوٍّ໑عٍِّهَٰہۧ😹👊ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'شسمك' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• اَٰسٌٍمٍٰـﮧهَٰہۧ عٍِّبٌِٰـﮧوٍّ໑سٌٍيَٰ لْٰـوٍّ૭سٌٍہيَٰ😾😹💛ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'شوف' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• شَُشَُـﮧﮧوٍّ໑فِٰ 🌝🌝ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'مساء الخير' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• مٍٰسٌٍـﮧاَٰء اَٰلْٰحٌٰـﮧبٌِٰ يَٰحٌٰہبٌِٰحٌٰہبٌِٰ🌛🔥ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'المدرسه' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• لْٰتّٰجًِّيَٰـﮧبٌِٰ اَٰسٌٍمٍٰـﮧهَٰہۧ لْٰاَٰ اَٰطَُِـﮧرِٰدِٰكٍٰ🌞✨ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'منو ديحذف رسائلي' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• خّٰـﮧاَٰلْٰتّٰـہكٍٰ 🌚ֆ🌝"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'البوت واكف' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• لْٰجًِّـﮧذَْبٌِٰ حٌٰبٌِٰـہيَٰ 🌞⚡️ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'غلس' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• وٍّ໑كٍٰ بٌِٰـﮧسٌٍ سٌٍـﮧوٍّ୭لْٰفِٰلْٰيَٰ اَٰلْٰسٌٍـﮧاَٰلْٰفِٰهَٰہۧ بٌِٰعٍِّـﮧدِٰيَٰنٍٰ🌝🦅ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'حارة' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• تّٰسٌٍـہمٍٰطَُِ سٌٍمٍٰـﮧطَُِ غِِٰيَٰـﮧرِٰ يَٰرِٰحٌٰمٍٰنٍٰـﮧهَٰہۧ اَٰلْٰاَٰعٍِّبٌِٰـاَٰدِٰيَٰ وٍّيَٰنٍٰـہطَُِيَٰ عٍِّطَُِلْٰـﮧهَٰہۧ 😾💔ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'هههه' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• نٍٰشَُـﮧاَٰلْٰلْٰهَٰہۧ دِٰاَٰيَٰمٍٰـﮧهَٰہۧ💆🏻‍♂💘ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'ههههه' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• نٍٰشَُـﮧاَٰلْٰلْٰهَٰہۧ دِٰاَٰيَٰمٍٰـﮧهَٰہۧ💆🏻‍♂💘ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😹' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• نٍٰشَُـﮧاَٰلْٰلْٰهَٰہۧ دِٰاَٰيَٰمٍٰـﮧهَٰہۧ💆🏻‍♂💘ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'وين' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• بٌِٰـﮧﮧأرِٰض اَٰلْٰلْٰهَٰہۧ اَٰلْٰـہوٍّاَٰسٌٍعٍِّـﮧهَٰہۧ😽💜ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'كافي لغوة' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• كٍٰـيَٰفِٰنٍٰـﮧهَٰہۧ نٍٰتّٰـﮧهَٰہۧ شَُعٍِّـہلْٰيَٰكٍٰ😼👊ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'نايمين' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• اَٰنٍٰـﮧيَٰ سٌٍهَٰہۧـہرِٰاَٰنٍٰ اَٰحٌٰرِٰسٌٍـﮧكٍٰمٍٰ مٍٰـﮧטּ تّٰـرِٰاَٰمٍٰـﮧبٌِٰ😿😹🙌ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'اكو احد' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• يَٰ عٍِّيَٰـنٍٰـﮧيَٰ اَٰنٍٰـہيَٰ مٍٰـوٍّ૭جًِّـﮧوٍّدِٰ🌝✨ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'فديت' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "•فِٰـﮧﮧدِٰاَٰكٍٰ/جًِّ ثِْْـﮧوٍّ୪لْٰاَٰنٍٰ اَٰلْٰكٍٰـرِٰوٍّ୭بٌِٰ😟😂💚ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'شكو' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• كٍٰلْٰـشَُـﮧﮧيَٰ مٍٰـہاَٰكٍٰـﮧوٍّ اَٰرِٰجًِّـعٍِّ نٍٰـاَٰمٍٰ🐼🌩ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'اوف' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• هَٰہۧـﮧﮧاَٰيَٰ اَٰوٍّفِٰ مٍٰنٍٰ يَٰـاَٰ نٍٰـوٍّ୭عٍِّ صُِـاَٰرِٰتّٰ اَٰلْٰـسٌٍاَٰلْٰفِٰهَٰہۧ مٍٰتّٰـنٍٰعٍِّرِٰفِٰ🌚🌙ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'احبج' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "•جًِّـﮧذَْاَٰبٌِٰ يَٰـرِٰيَٰدِٰ يَٰطَُِـہكٍٰجًِّ😹🌞⚡️ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'انتة منو' then
if not database:get('bot:rep:mute'..msg.chat_id_) then
moody = "• اَٰنٍٰـﮧﮧيَٰ بٌِٰـوٍّ໑تّٰ💨🌝ֆ"
else
moody = ''
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
------------------------------------ With Pattern -------------------------------------------
	if text:match("^[Ll][Ee][Aa][Vv][Ee]$") and is_sudo(msg) and not tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if not database:get('bot:leave:groups') then
	chat_leave(msg.chat_id_, bot_id)
send(msg.chat_id_, msg.id_, 1, "_Group_ *Left*", 1, 'md')
else
end
end

	if text:match("^مغادره$") and is_sudo(msg) and not tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if not database:get('bot:leave:groups') then
	chat_leave(msg.chat_id_, bot_id)
send(msg.chat_id_, msg.id_, 1, "☑️┇تم مغادره المجموعه", 1, 'md')
else
end
end

	if text:match("^[Ll][Ee][Aa][Vv][Ee]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
	chat_leave(msg.chat_id_, bot_id)
send(msg.chat_id_, msg.id_, 1, "_Group_ *Left*", 1, 'md')
end

	if text:match("^مغادره$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
	chat_leave(msg.chat_id_, bot_id)
send(msg.chat_id_, msg.id_, 1, "☑️┇تم مغادره المجموعه", 1, 'md')
end


if msg.content_.entities_ then
if msg.content_.entities_[0] then
if msg.content_.entities_[0] and msg.content_.entities_[0].ID == "MessageEntityUrl" or msg.content_.entities_[0].ID == "MessageEntityTextUrl" then
if database:get('bot:markdown:mute'..msg.chat_id_) then
if not is_vip(msg.sender_user_id_, msg.chat_id_) then
  delete_msg(msg.chat_id_, {[0] = msg.id_})
end
if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
 if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
end
if database:get('bot:markdown:ban'..msg.chat_id_) then
if not is_vip(msg.sender_user_id_, msg.chat_id_) then
delete_msg(msg.chat_id_, {[0] = msg.id_})
chat_kick(msg.chat_id_, msg.sender_user_id_)
  send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الماركدون تم قفلها ممنوع ارسالها️\n🚷┇تم طردك من المجموعه", 1, 'html')
end
if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
 if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
end
if database:get('bot:markdown:warn'..msg.chat_id_) then
if not is_vip(msg.sender_user_id_, msg.chat_id_) then
delete_msg(msg.chat_id_, {[0] = msg.id_})
  send(msg.chat_id_, 0, 1, "🎫┇الايدي ~⪼ ("..msg.sender_user_id_..")\n❕┇الماركدون تم قفلها ممنوع ارسالها️", 1, 'html')
end
if msg.forward_info_ then
if database:get('bot:forward:mute'..msg.chat_id_) then
 if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
end
end
end
end
end
end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('رفع ادمن','setmote')
	if text:match("^[Ss][Ee][Tt][Mm][Oo][Tt][Ee]$")  and is_owner(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function promote_by_reply(extra, result, success)
	local hash = 'bot:mods:'..msg.chat_id_
	if database:sismember(hash, result.sender_user_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is Already moderator._', 1, 'md')
  else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')*\n☑┇بالفعل تم رفعه ادمن', 1, 'md')
  end
else
   database:sadd(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _promoted as moderator._', 1, 'md')
  else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇تم رفعه ادمن', 1, 'md')
  end
	end
end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ee][Tt][Mm][Oo][Tt][Ee] @(.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local apmd = {string.match(text, "^([Ss][Ee][Tt][Mm][Oo][Tt][Ee]) @(.*)$")}
	function promote_by_username(extra, result, success)
	if result.id_ then
	  database:sadd('bot:mods:'..msg.chat_id_, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User '..result.id_..' promoted as moderator.!</code>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..')\n☑️┇تم رفعه ادمن'
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apmd[2],promote_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ee][Tt][Mm][Oo][Tt][Ee] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local apmd = {string.match(text, "^([Ss][Ee][Tt][Mm][Oo][Tt][Ee]) (%d+)$")}
	  database:sadd('bot:mods:'..msg.chat_id_, apmd[2])
if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apmd[2]..'* _promoted as moderator._', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apmd[2]..')* \n☑┇تم رفعه ادمن️', 1, 'md')
end
end
	-----------------------------------------------------------------------------------------------
  local text = msg.content_.text_:gsub('تنزيل ادمن','remmote')
	if text:match("^[Rr][Ee][Mm][Mm][Oo][Tt][Ee]$") and is_owner(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function demote_by_reply(extra, result, success)
	local hash = 'bot:mods:'..msg.chat_id_
	if not database:sismember(hash, result.sender_user_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is not Promoted._', 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* ️\n☑┇ بالفعل تم تنزيله من ادمنيه البوت', 1, 'md')
  end
	else
   database:srem(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then

   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _Demoted._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇ تم تنزيله من ادمنيه البوت', 1, 'md')
	end
  end
  end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,demote_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Rr][Ee][Mm][Mm][Oo][Tt][Ee] @(.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local hash = 'bot:mods:'..msg.chat_id_
	local apmd = {string.match(text, "^([Rr][Ee][Mm][Mm][Oo][Tt][Ee]) @(.*)$")}
	function demote_by_username(extra, result, success)
	if result.id_ then
   database:srem(hash, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>Demoted</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..') \n☑┇ تم تنزيله من ادمنيه البوت️'
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء️'
  end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apmd[2],demote_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Rr][Ee][Mm][Mm][Oo][Tt][Ee] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local hash = 'bot:mods:'..msg.chat_id_
	local apmd = {string.match(text, "^([Rr][Ee][Mm][Mm][Oo][Tt][Ee]) (%d+)$")}
   database:srem(hash, apmd[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apmd[2]..'* _Demoted._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apmd[2]..')*  \n☑┇ تم تنزيله من ادمنيه البوت️ ', 1, 'md')
  end
  end
  -----------------------------------------------------------------------------------------------
  local text = msg.content_.text_:gsub('رفع عضو مميز','setvip')
	if text:match("^[Ss][Ee][Tt][Vv][Ii][Pp]$")  and is_owner(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function promote_by_reply(extra, result, success)
	local hash = 'bot:vipgp:'..msg.chat_id_
	if database:sismember(hash, result.sender_user_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is Already vip._', 1, 'md')
  else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇بالفعل تم رفعه عضو مميز', 1, 'md')
  end
else
   database:sadd(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _promoted as vip._', 1, 'md')
  else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇تم رفعه عضو مميز', 1, 'md')
  end
	end
end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ee][Tt][Vv][Ii][Pp] @(.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local apmd = {string.match(text, "^([Ss][Ee][Tt][Vv][Ii][Pp]) @(.*)$")}
	function promote_by_username(extra, result, success)
	if result.id_ then
	  database:sadd('bot:vipgp:'..msg.chat_id_, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User '..result.id_..' promoted as vip.!</code>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..')\n☑┇تم رفعه عضو مميز'
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء️'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apmd[2],promote_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ee][Tt][Vv][Ii][Pp] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local apmd = {string.match(text, "^([Ss][Ee][Tt][Vv][Ii][Pp]) (%d+)$")}
	  database:sadd('bot:vipgp:'..msg.chat_id_, apmd[2])
if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apmd[2]..'* _promoted as vip._', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apmd[2]..')* \n☑┇تم رفعه عضو مميز', 1, 'md')
end
end
	-----------------------------------------------------------------------------------------------
  local text = msg.content_.text_:gsub('تنزيل عضو مميز','remvip')
	if text:match("^[Rr][Ee][Mm][Vv][Ii][Pp]$") and is_owner(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function demote_by_reply(extra, result, success)
	local hash = 'bot:vipgp:'..msg.chat_id_
	if not database:sismember(hash, result.sender_user_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is not Promoted vip._', 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n ☑┇بالفعل تم تنزيله من اعضاء الممزين البوت', 1, 'md')
  end
	else
   database:srem(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then

   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _Demoted vip._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇تم تنزيله من اعضاء الممزين البوت', 1, 'md')
	end
  end
  end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,demote_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Rr][Ee][Mm][Vv][Ii][Pp] @(.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local hash = 'bot:vipgp:'..msg.chat_id_
	local apmd = {string.match(text, "^([Rr][Ee][Mm][Vv][Ii][Pp]) @(.*)$")}
	function demote_by_username(extra, result, success)
	if result.id_ then
   database:srem(hash, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>Demoted vip</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..') \n☑┇تم تنزيله من اعضاء الممزين البوت️'
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء️'
  end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apmd[2],demote_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Rr][Ee][Mm][Vv][Ii][Pp] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local hash = 'bot:vipgp:'..msg.chat_id_
	local apmd = {string.match(text, "^([Rr][Ee][Mm][Vv][Ii][Pp]) (%d+)$")}
   database:srem(hash, apmd[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apmd[2]..'* _Demoted vip._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *'..apmd[2]..'* \n☑┇تم تنزيله من اعضاء الممزين البوت ️', 1, 'md')
  end
  end

	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('حظر','Ban')
	if text:match("^[Bb][Aa][Nn]$") and is_mod(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function ban_by_reply(extra, result, success)
	local hash = 'bot:banned:'..msg.chat_id_
	if is_mod(result.sender_user_id_, result.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Kick/Ban] Moderators!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع حظر \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
if database:sismember(hash, result.sender_user_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is Already Banned._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* ️\n☑┇بالفعل تم حظره من المجموعه', 1, 'md')
end
		 chat_kick(result.chat_id_, result.sender_user_id_)
	else
   database:sadd(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _Banned._', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇تم حظره من المجموعه', 1, 'md')
end
		 chat_kick(result.chat_id_, result.sender_user_id_)
	end
end
	end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,ban_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Bb][Aa][Nn] @(.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local apba = {string.match(text, "^([Bb][Aa][Nn]) @(.*)$")}
	function ban_by_username(extra, result, success)
	if result.id_ then
	if is_mod(result.id_, msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Kick/Ban] Moderators!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع حظر \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
	  database:sadd('bot:banned:'..msg.chat_id_, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>Banned.!</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..')\n☑┇تم حظره من المجموعه'
end
		 chat_kick(msg.chat_id_, result.id_)
	end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء️'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apba[2],ban_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Bb][Aa][Nn] (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local apba = {string.match(text, "^([Bb][Aa][Nn]) (%d+)$")}
	if is_mod(apba[2], msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Kick/Ban] Moderators!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع حظر \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
	  database:sadd('bot:banned:'..msg.chat_id_, apba[2])
		 chat_kick(msg.chat_id_, apba[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apba[2]..'* _Banned._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apba[2]..')* \n☑┇تم حظره من المجموعه', 1, 'md')
  	end
	end
end
  ----------------------------------------------unban--------------------------------------------
local text = msg.content_.text_:gsub('الغاء حظر','unban')
  	if text:match("^[Uu][Nn][Bb][Aa][Nn]$") and is_mod(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function unban_by_reply(extra, result, success)
	local hash = 'bot:banned:'..msg.chat_id_
	if not database:sismember(hash, result.sender_user_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is not Banned._', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇بالفعل تم الغاء حظره من البوت\n', 1, 'md')
end
	else
   database:srem(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _Unbanned._', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇تم الغاء حظره من البوت️', 1, 'md')
end
	end
end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,unban_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Uu][Nn][Bb][Aa][Nn] @(.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local apba = {string.match(text, "^([Uu][Nn][Bb][Aa][Nn]) @(.*)$")}
	function unban_by_username(extra, result, success)
	if result.id_ then
   database:srem('bot:banned:'..msg.chat_id_, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>Unbanned.!</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..')\n☑┇تم الغاء حظره من البوت️'
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء️'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apba[2],unban_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Uu][Nn][Bb][Aa][Nn] (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local apba = {string.match(text, "^([Uu][Nn][Bb][Aa][Nn]) (%d+)$")}
	  database:srem('bot:banned:'..msg.chat_id_, apba[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apba[2]..'* _Unbanned._', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apba[2]..')* \n☑┇تم الغاء حظره من البوت️', 1, 'md')
end
  end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('حذف الكل','delall')
	if text:match("^[Dd][Ee][Ll][Aa][Ll][Ll]$") and is_owner(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function delall_by_reply(extra, result, success)
	if is_mod(result.sender_user_id_, result.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t Delete Msgs from Moderators!!*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع مسح رسائل \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_All Msgs from _ *'..result.sender_user_id_..'* _Has been deleted!!_', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n🗑┇تم حذف كل رسائله\n', 1, 'md')
end
		del_all_msgs(result.chat_id_, result.sender_user_id_)
end
	end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,delall_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Dd][Ee][Ll][Aa][Ll][Ll] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
		local ass = {string.match(text, "^([Dd][Ee][Ll][Aa][Ll][Ll]) (%d+)$")}
	if is_mod(ass[2], msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t Delete Msgs from Moderators!!*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع مسح رسائل \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
	 		del_all_msgs(msg.chat_id_, ass[2])
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_All Msgs from _ *'..ass[2]..'* _Has been deleted!!_', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..ass[2]..')* \n🗑┇تم حذف كل رسائله\n', 1, 'md')
end
  end
	end
 -----------------------------------------------------------------------------------------------
	if text:match("^[Dd][Ee][Ll][Aa][Ll][Ll] @(.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local apbll = {string.match(text, "^([Dd][Ee][Ll][Aa][Ll][Ll]) @(.*)$")}
	function delall_by_username(extra, result, success)
	if result.id_ then
	if is_mod(result.id_, msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t Delete Msgs from Moderators!!*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع مسح رسائل \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
return false
end
		 		del_all_msgs(msg.chat_id_, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>All Msg From user</b> <code>'..result.id_..'</code> <b>Deleted!</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..') \n🗑┇تم حذف كل رسائله'
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء️️'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apbll[2],delall_by_username)
end
  -----------------------------------------banall--------------------------------------------------
local text = msg.content_.text_:gsub('حظر عام','banall')
if text:match("^[Bb][Aa][Nn][Aa][Ll][Ll]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) and msg.reply_to_message_id_ then
function gban_by_reply(extra, result, success)
  local hash = 'bot:gbanned:'
	if is_admin(result.sender_user_id_, result.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Banall] admins/sudo!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع حظر عام \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
  database:sadd(hash, result.sender_user_id_)
  chat_kick(result.chat_id_, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
  texts = '<b>User :</b> '..result.sender_user_id_..' <b>Has been Globally Banned !</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.sender_user_id_..') \n🚫┇تم حظره من مجموعات البوت'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,gban_by_reply)
end
-----------------------------------------------------------------------------------------------
if text:match("^[Bb][Aa][Nn][Aa][Ll][Ll] @(.*)$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local apbll = {string.match(text, "^([Bb][Aa][Nn][Aa][Ll][Ll]) @(.*)$")}
function gban_by_username(extra, result, success)
  if result.id_ then
   	if is_admin(result.id_, msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Banall] admins/sudo!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع حظر عام \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
  else
  local hash = 'bot:gbanned:'
if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User :</b> <code>'..result.id_..'</code> <b> Has been Globally Banned !</b>'
  else
texts = '👤┇العضو ~⪼ ('..result.id_..') \n🚫┇تم حظره من المجموعات البوت'
end
database:sadd(hash, result.id_)
end
  else
if database:get('bot:lang:'..msg.chat_id_) then
  texts = '<b>User not found!</b>'
else
  texts = '✖┇خطاء'
end
end
  send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
resolve_username(apbll[2],gban_by_username)
end

if text:match("^[Bb][Aa][Nn][Aa][Ll][Ll] (%d+)$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local apbll = {string.match(text, "^([Bb][Aa][Nn][Aa][Ll][Ll]) (%d+)$")}
  local hash = 'bot:gbanned:'
	  database:sadd(hash, apbll[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apbll[2]..'* _Has been Globally Banned _', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apbll[2]..')* \n🚫┇تم حظره من المجموعات البوت', 1, 'md')
	end
end
-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('الغاء العام','unbanall')
if text:match("^[Uu][Nn][Bb][Aa][Nn][Aa][Ll][Ll]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) and msg.reply_to_message_id_ then
function ungban_by_reply(extra, result, success)
  local hash = 'bot:gbanned:'
  if database:get('bot:lang:'..msg.chat_id_) then
  texts = '<b>User :</b> '..result.sender_user_id_..' <b>Has been Globally Unbanned !</b>'
 else
  texts =  '👤┇العضو ~⪼ ('..result.sender_user_id_..') \n🚫┇تم الغاء حظره من المجموعات البوت️'
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
  database:srem(hash, result.sender_user_id_)
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,ungban_by_reply)
end
-----------------------------------------------------------------------------------------------
if text:match("^[Uu][Nn][Bb][Aa][Nn][Aa][Ll][Ll] @(.*)$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local apid = {string.match(text, "^([Uu][Nn][Bb][Aa][Nn][Aa][Ll][Ll]) @(.*)$")}
function ungban_by_username(extra, result, success)
  local hash = 'bot:gbanned:'
  if result.id_ then
if database:get('bot:lang:'..msg.chat_id_) then
 texts = '<b>User :</b> '..result.id_..' <b>Has been Globally Unbanned !</b>'
else
texts = '👤┇العضو ~⪼ ('..result.id_..') \n🚫┇تم الغاء حظره من المجموعات البوت️'
end
database:srem(hash, result.id_)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  texts = '<b>User not found!</b>'
else
  texts = '✖┇خطاء'
  end
  end
  send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
resolve_username(apid[2],ungban_by_username)
end
-----------------------------------------------------------------------------------------------
if text:match("^[Uu][Nn][Bb][Aa][Nn][Aa][Ll][Ll] (%d+)$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local apbll = {string.match(text, "^([Uu][Nn][Bb][Aa][Nn][Aa][Ll][Ll]) (%d+)$")}
local hash = 'bot:gbanned:'
  database:srem(hash, apbll[2])
  if database:get('bot:lang:'..msg.chat_id_) then
  texts = '<b>User :</b> '..apbll[2]..' <b>Has been Globally Unbanned !</b>'
else
texts = '👤┇العضو ~⪼ ('..apbll[2]..') \n🚫┇تم الغاء حظره من مجموعات البوت️'
end
  send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('كتم عام','silent all')
if text:match("^[Ss][Ii][Ll][Ee][Nn][Tt] [Aa][Ll][Ll]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) and msg.reply_to_message_id_ then
function gmute_by_reply(extra, result, success)
  local hash = 'bot:gmuted:'
	if is_admin(result.sender_user_id_, result.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Banall] admins/sudo!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع كتم عام \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
  database:sadd(hash, result.sender_user_id_)
  chat_kick(result.chat_id_, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
  texts = '<b>User :</b> '..result.sender_user_id_..' <b>Has been Gmuted Banned !</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.sender_user_id_..') \n🚫┇تم كتمه من المجموعات البوت'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,gmute_by_reply)
end
-----------------------------------------------------------------------------------------------
if text:match("^[Ss][Ii][Ll][Ee][Nn][Tt] [Aa][Ll][Ll] @(.*)$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local apbll = {string.match(text, "^([Ss][Ii][Ll][Ee][Nn][Tt] [Aa][Ll][Ll]) @(.*)$")}
function gmute_by_username(extra, result, success)
  if result.id_ then
   	if is_admin(result.id_, msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Banall] admins/sudo!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع كتم عام \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
  else
  local hash = 'bot:gmuted:'
if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User :</b> <code>'..result.id_..'</code> <b> Has been Gmuted Banned !</b>'
  else
texts = '👤┇العضو ~⪼ ('..result.id_..') \n🚫┇تم كتمه من المجموعات البوت'
end
database:sadd(hash, result.id_)
end
  else
if database:get('bot:lang:'..msg.chat_id_) then
  texts = '<b>User not found!</b>'
else
  texts = '✖┇خطاء'
end
end
  send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
resolve_username(apbll[2],gmute_by_username)
end

if text:match("^[Ss][Ii][Ll][Ee][Nn][Tt] [Aa][Ll][Ll] (%d+)$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local apbll = {string.match(text, "^([Ss][Ii][Ll][Ee][Nn][Tt] [Aa][Ll][Ll]) (%d+)$")}
  local hash = 'bot:gmuted:'
	  database:sadd(hash, apbll[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apbll[2]..'* _Has been Gmuted Banned _', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apbll[2]..')* \n🚫┇تم كتمه من المجموعات البوت', 1, 'md')
	end
end
-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('الغاء كتم العام','unsilent all')
if text:match("^[Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt] [Aa][Ll][Ll]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) and msg.reply_to_message_id_ then
function ungmute_by_reply(extra, result, success)
  local hash = 'bot:gmuted:'
  if database:get('bot:lang:'..msg.chat_id_) then
  texts = '<b>User :</b> '..result.sender_user_id_..' <b>Has been Gmuted Unbanned !</b>'
 else
  texts = '👤┇العضو ~⪼ ('..result.sender_user_id_..') \n🚫┇تم الغاء كتمه من المجموعات البوت️'
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
  database:srem(hash, result.sender_user_id_)
end
getMessage(msg.chat_id_, msg.reply_to_message_id_,ungmute_by_reply)
end
-----------------------------------------------------------------------------------------------
if text:match("^[Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt] [Aa][Ll][Ll] @(.*)$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local apid = {string.match(text, "^([Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt] [Aa][Ll][Ll]) @(.*)$")}
function ungmute_by_username(extra, result, success)
  local hash = 'bot:gmuted:'
  if result.id_ then
if database:get('bot:lang:'..msg.chat_id_) then
 texts = '<b>User :</b> '..result.id_..' <b>Has been Gmuted Unbanned !</b>'
else
texts = '👤┇العضو ~⪼ ('..result.id_..') \n🚫┇تم الغاء كتمه من المجموعات البوت️'
end
database:srem(hash, result.id_)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  texts = '<b>User not found!</b>'
else
  texts = '✖┇خطاء'
  end
  end
  send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
resolve_username(apid[2],ungmute_by_username)
end
-----------------------------------------------------------------------------------------------
if text:match("^[Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt] [Aa][Ll][Ll] (%d+)$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local apbll = {string.match(text, "^([Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt] [Aa][Ll][Ll]) (%d+)$")}
local hash = 'bot:gmuted:'
  database:srem(hash, apbll[2])
  if database:get('bot:lang:'..msg.chat_id_) then
  texts = '<b>User :</b> '..apbll[2]..' <b>Has been Gmuted Unbanned !</b>'
else
texts = '👤┇العضو ~⪼ ('..apbll[2]..') \n🚫┇تم الغاء كتمه من المجموعات البوت️'
end
  send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('كتم','silent')
	if text:match("^[Ss][Ii][Ll][Ee][Nn][Tt]$") and is_mod(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function mute_by_reply(extra, result, success)
	local hash = 'bot:muted:'..msg.chat_id_
	if is_mod(result.sender_user_id_, result.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Kick/Ban] Moderators!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '❕┇لا تسطيع كتم \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
if database:sismember(hash, result.sender_user_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is Already silent._', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* /n🚫┇بافعل تم كتمه️', 1, 'md')
end
	else
   database:sadd(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _silent_', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n🚫┇تم كتمه من البوت', 1, 'md')
end
	end
end
	end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,mute_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ii][Ll][Ee][Nn][Tt] @(.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local apsi = {string.match(text, "^([Ss][Ii][Ll][Ee][Nn][Tt]) @(.*)$")}
	function mute_by_username(extra, result, success)
	if result.id_ then
	if is_mod(result.id_, msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Kick/Ban] Moderators!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '✖┇لا تسطيع كتم \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
	  database:sadd('bot:muted:'..msg.chat_id_, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>silent</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..') \n🚫┇تم كتمه من البوت'
end
	end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apsi[2],mute_by_username)
end

	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ii][Ll][Ee][Nn][Tt] (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local apsi = {string.match(text, "^([Ss][Ii][Ll][Ee][Nn][Tt]) (%d+)$")}
	if is_mod(apsi[2], msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Kick/Ban] Moderators!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '✖┇لا تسطيع كتم \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
	  database:sadd('bot:muted:'..msg.chat_id_, apsi[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apsi[2]..'* _Banned._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apsi[2]..')* \n🚫┇تم كتمه من البوت', 1, 'md')
  	end
	end
end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('الغاء كتم','unsilent')
	if text:match("^[Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt]$") and is_mod(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function unmute_by_reply(extra, result, success)
	local hash = 'bot:muted:'..msg.chat_id_
	if not database:sismember(hash, result.sender_user_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is not silent._', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n🚫┇بالفعل تم الغاء كتمه من البوت️', 1, 'md')
end
	else
   database:srem(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _unsilent_', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n🚫┇تم الغاء كتمه من البوت️', 1, 'md')
end
	end
end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,unmute_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt] @(.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local apsi = {string.match(text, "^([Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt]) @(.*)$")}
	function unmute_by_username(extra, result, success)
	if result.id_ then
   database:srem('bot:muted:'..msg.chat_id_, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>unsilent.!</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..') \n🚫┇تم الغاء كتمه من البوت️'
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apsi[2],unmute_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt] (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local apsi = {string.match(text, "^([Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt]) (%d+)$")}
	  database:srem('bot:muted:'..msg.chat_id_, apsi[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apsi[2]..'* _unsilent_', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apsi[2]..')* \n🚫┇تم الغاء كتمه من البوت️', 1, 'md')
end
  end
-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('طرد','kick')
  if text:match("^[Kk][Ii][Cc][Kk]$") and msg.reply_to_message_id_ and is_mod(msg.sender_user_id_, msg.chat_id_) then
function kick_reply(extra, result, success)
	if is_mod(result.sender_user_id_, result.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Kick] Moderators!!*', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '✖┇لا تستطيع طرد \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '*User* _'..result.sender_user_id_..'_ *Kicked.*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ ('..result.sender_user_id_..') \n🚫┇تم طرده من المجموعه', 1, 'md')
end
  chat_kick(result.chat_id_, result.sender_user_id_)
  end
	end
   getMessage(msg.chat_id_,msg.reply_to_message_id_,kick_reply)
  end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Kk][Ii][Cc][Kk] @(.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local apki = {string.match(text, "^([Kk][Ii][Cc][Kk]) @(.*)$")}
	function kick_by_username(extra, result, success)
	if result.id_ then
	if is_mod(result.id_, msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Kick] Moderators!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '✖┇لا تستطيع طرد \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>Kicked.!</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..') \n🚫┇تم طرده من المجموعه'
end
		 chat_kick(msg.chat_id_, result.id_)
	end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apki[2],kick_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Kk][Ii][Cc][Kk] (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local apki = {string.match(text, "^([Kk][Ii][Cc][Kk]) (%d+)$")}
	if is_mod(apki[2], msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*You Can,t [Kick] Moderators!!*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '✖┇لا تستطيع طرد \n🔘┇(مدراء،ادمنيه،اعضاء مميزين)البوت', 1, 'md')
end
else
		 chat_kick(msg.chat_id_, apki[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apki[2]..'* _Kicked._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ ('..apki[2]..') \n🚫┇تم طرده من المجموعه', 1, 'md')
  	end
	end
end
-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('رفع مدير','setowner')
	if text:match("^[Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr]$") and is_creator(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function setowner_by_reply(extra, result, success)
	local hash = 'bot:owners:'..msg.chat_id_
	if database:sismember(hash, result.sender_user_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is Already Owner._', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇بالفعل تم رفع مدير في البوت', 1, 'md')
end
	else
   database:sadd(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _Promoted as Group Owner._', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇تم رفع مدير في البوت', 1, 'md')
end
	end
end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,setowner_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr] @(.*)$") and is_creator(msg.sender_user_id_, msg.chat_id_) then
	local apow = {string.match(text, "^([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr]) @(.*)$")}
	function setowner_by_username(extra, result, success)
	if result.id_ then
	  database:sadd('bot:owners:'..msg.chat_id_, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>Promoted as Group Owner.!</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..') \n☑┇تم رفع مدير في البوت'
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apow[2],setowner_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr] (%d+)$") and is_creator(msg.sender_user_id_, msg.chat_id_) then
	local apow = {string.match(text, "^([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr]) (%d+)$")}
	  database:sadd('bot:owners:'..msg.chat_id_, apow[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apow[2]..'* _Promoted as Group Owner._', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apow[2]..')* \n☑┇تم رفع مدير في البوت', 1, 'md')
end
end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('تنزيل مدير','remowner')
	if text:match("^[Rr][Ee][Mm][Oo][Ww][Nn][Ee][Rr]$") and is_creator(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
	function deowner_by_reply(extra, result, success)
	local hash = 'bot:owners:'..msg.chat_id_
	if not database:sismember(hash, result.sender_user_id_) then
	if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is not Owner._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇بالفعل تم تنزيله من مدراء البوت', 1, 'md')
end
	else
   database:srem(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _Removed from ownerlist._', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇تم تنزيله من مدراء البوت', 1, 'md')
end
	end
end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,deowner_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Rr][Ee][Mm][Oo][Ww][Nn][Ee][Rr] @(.*)$") and is_creator(msg.sender_user_id_, msg.chat_id_) then
	local apow = {string.match(text, "^([Rr][Ee][Mm][Oo][Ww][Nn][Ee][Rr]) @(.*)$")}
	local hash = 'bot:owners:'..msg.chat_id_
	function remowner_by_username(extra, result, success)
	if result.id_ then
   database:srem(hash, result.id_)
	if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>Removed from ownerlist</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..') \n☑┇تم تنزيله من مدراء البوت'
end
else
	if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apow[2],remowner_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Rr][Ee][Mm][Oo][Ww][Nn][Ee][Rr] (%d+)$") and is_creator(msg.sender_user_id_, msg.chat_id_) then
	local hash = 'bot:owners:'..msg.chat_id_
	local apow = {string.match(text, "^([Rr][Ee][Mm][Oo][Ww][Nn][Ee][Rr]) (%d+)$")}
   database:srem(hash, apow[2])
	if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apow[2]..'* _Removed from ownerlist._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apow[2]..')* \n☑┇تم تنزيله من مدراء البوت', 1, 'md')
end
end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('رفع منشئ','set creator')
	if text:match("^[Ss][Ee][Tt] [Cc][Rr][Ee][Aa][Tt][Oo][Rr]$") and is_sudo(msg) and msg.reply_to_message_id_ then
	function setcreator_by_reply(extra, result, success)
	local hash = 'bot:creator:'..msg.chat_id_
	if database:sismember(hash, result.sender_user_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is Already creator._', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇بالفعل تم رفع منشئ في البوت', 1, 'md')
end
	else
   database:sadd(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _Promoted as Group creator._', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇تم رفع منشئ في البوت', 1, 'md')
end
	end
end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,setcreator_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ee][Tt] [Cc][Rr][Ee][Aa][Tt][Oo][Rr] @(.*)$") and is_sudo(msg) then
	local apow = {string.match(text, "^([Ss][Ee][Tt] [Cc][Rr][Ee][Aa][Tt][Oo][Rr]) @(.*)$")}
	function setcreator_by_username(extra, result, success)
	if result.id_ then
	  database:sadd('bot:creator:'..msg.chat_id_, result.id_)
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>Promoted as Group creator.!</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..') \n☑┇تم رفع منشئ في البوت'
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apow[2],setcreator_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ee][Tt] [Cc][Rr][Ee][Aa][Tt][Oo][Rr] (%d+)$") and is_sudo(msg) then
	local apow = {string.match(text, "^([Ss][Ee][Tt] [Cc][Rr][Ee][Aa][Tt][Oo][Rr]) (%d+)$")}
	  database:sadd('bot:creator:'..msg.chat_id_, apow[2])
  if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apow[2]..'* _Promoted as Group creator._', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apow[2]..')* \n☑┇تم رفع منشئ في البوت', 1, 'md')
end
end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('تنزيل منشئ','rem creator')
	if text:match("^[Rr][Ee][Mm] [Cc][Rr][Ee][Aa][Tt][Oo][Rr]$") and is_sudo(msg) and msg.reply_to_message_id_ then
	function decreator_by_reply(extra, result, success)
	local hash = 'bot:creator:'..msg.chat_id_
	if not database:sismember(hash, result.sender_user_id_) then
	if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _is not creator._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇بالفعل تم تنزيله من منشئين المجموعه', 1, 'md')
end
	else
   database:srem(hash, result.sender_user_id_)
  if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_User_ *'..result.sender_user_id_..'* _Removed from creatorlist._', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..result.sender_user_id_..')* \n☑┇تم تنزيله من منشئين المجموعه', 1, 'md')
end
	end
end
	getMessage(msg.chat_id_, msg.reply_to_message_id_,decreator_by_reply)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Rr][Ee][Mm] [Cc][Rr][Ee][Aa][Tt][Oo][Rr] @(.*)$") and is_sudo(msg) then
	local apow = {string.match(text, "^([Rr][Ee][Mm] [Cc][Rr][Ee][Aa][Tt][Oo][Rr]) @(.*)$")}
	local hash = 'bot:creator:'..msg.chat_id_
	function remcreator_by_username(extra, result, success)
	if result.id_ then
   database:srem(hash, result.id_)
	if database:get('bot:lang:'..msg.chat_id_) then
texts = '<b>User </b><code>'..result.id_..'</code> <b>Removed from creatorlist</b>'
else
  texts = '👤┇العضو ~⪼ ('..result.id_..') \n☑┇تم تنزيله من منشئين المجموعه'
end
else
	if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
  texts = '✖┇خطاء'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(apow[2],remcreator_by_username)
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Rr][Ee][Mm] [Cc][Rr][Ee][Aa][Tt][Oo][Rr] (%d+)$") and is_sudo(msg) then
	local hash = 'bot:creator:'..msg.chat_id_
	local apow = {string.match(text, "^([Rr][Ee][Mm] [Cc][Rr][Ee][Aa][Tt][Oo][Rr]) (%d+)$")}
   database:srem(hash, apow[2])
	if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_User_ *'..apow[2]..'* _Removed from creatorlist._', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '👤┇العضو ~⪼ *('..apow[2]..')* \n☑┇تم تنزيله من منشئين المجموعه', 1, 'md')
end
  end
	-----------------------------------------------------------------------------------------------
if text:match("^[Mm][Oo][Dd][Ll][Ii][Ss]$") and is_owner(msg.sender_user_id_, msg.chat_id_) or text:match("^[Mm][Oo][Dd][Ll][Ii][Ss][Tt]$") and is_owner(msg.sender_user_id_, msg.chat_id_) or text:match("^الادمنيه$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
local hash =  'bot:mods:'..msg.chat_id_
  local list = database:smembers(hash)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>Mod List:</b>\n\n"
else
  text = "👥┇قائمة الادمنيه ،\n-------------\n"
  end
  for k,v in pairs(list) do
  local user_info = database:hgetall('user:'..v)
if user_info and user_info.username then
local username = user_info.username
text = text.."<b>|"..k.."|</b>~⪼(@"..username..")\n"
else
text = text.."<b>|"..k.."|</b>~⪼(<code>"..v.."</code>)\n"
end
  end
  if #list == 0 then
if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>Mod List is empty !</b>"
  else
text = "✖┇لايوجد ادمنيه"
end
end
  send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
-----------------------------------------------

-----------------------------------------------
	if text:match("^[Vv][Ii][Pp][Ll][Ii][Ss][Tt]$") and is_owner(msg.sender_user_id_, msg.chat_id_) or text:match("^الاعضاء المميزين") and is_owner(msg.sender_user_id_, msg.chat_id_) then
local hash =  'bot:vipgp:'..msg.chat_id_
	local list = database:smembers(hash)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>Vip List:</b>\n\n"
else
  text = "👥┇قائمة الاعضاء المميزين ،\n-------------\n"
  end
	for k,v in pairs(list) do
	local user_info = database:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text.."<b>|"..k.."|</b>~⪼(@"..username..")\n"
else
  text = text.."<b>|"..k.."|</b>~⪼(<code>"..v.."</code>)\n"
		end
	end
	if #list == 0 then
	   if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>Vip List is empty !</b>"
  else
 text = "✖┇لايوجد اعضاء مميزين"
end
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
  end

if text:match("^[Bb][Aa][Dd][Ll][Ii][Ss][Tt]$") and is_mod(msg.sender_user_id_, msg.chat_id_) or text:match("^قائمه المنع$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
  local hash = 'bot:filters:'..msg.chat_id_
if hash then
   local names = database:hkeys(hash)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>bad List:</b>\n\n"
else
  text = "⚠┇قائمة الكلمات الممنوعه ،\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
  end
  for i=1, #names do
 text = text.."<b>|"..i.."|</b>~⪼("..names[i]..")\n"
end
  if #names == 0 then
if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>bad List is empty !</b>"
  else
text = "✖┇لايوجد كلمات ممنوعه"
end
end
send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
 end
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ii][Ll][Ee][Nn][Tt][Ll][Ii][Ss][Tt]$") and is_mod(msg.sender_user_id_, msg.chat_id_) or text:match("^المكتومين$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
local hash =  'bot:muted:'..msg.chat_id_
	local list = database:smembers(hash)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>Silent List:</b>\n\n"
else
  text = "🚫┇قائمة المتومين  ،\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
end
for k,v in pairs(list) do
	local user_info = database:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text.."<b>|"..k.."|</b>~⪼(@"..username..")\n"
else
  text = text.."<b>|"..k.."|</b>~⪼(<code>"..v.."</code>)\n"
		end
	end
	if #list == 0 then
	   if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>Mod List is empty !</b>"
  else
text = "✖┇لايوجد مكتومين"
end
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Oo][Ww][Nn][Ee][Rr][Ss]$") and is_creator(msg.sender_user_id_, msg.chat_id_) or text:match("^[Oo][Ww][Nn][Ee][Rr][Ll][Ii][Ss][Tt]$") and is_creator(msg.sender_user_id_, msg.chat_id_) or text:match("^المدراء$") and is_creator(msg.sender_user_id_, msg.chat_id_) then
local hash =  'bot:owners:'..msg.chat_id_
	local list = database:smembers(hash)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>owner List:</b>\n\n"
else
  text = "🛄┇قائمة المدراء  ،\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
end
for k,v in pairs(list) do
	local user_info = database:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text.."<b>|"..k.."|</b>~⪼(@"..username..")\n"
else
  text = text.."<b>|"..k.."|</b>~⪼(<code>"..v.."</code>)\n"
		end
	end
	if #list == 0 then
	   if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>owner List is empty !</b>"
  else
text = "✖┇لايوجد مدراء"
end
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
  end

	if text:match("^[Cc][Rr][Ee][Aa][Tt][Oo][Rr][Ss]$") and is_sudo(msg) or text:match("^[Cc][Rr][Ee][Aa][Tt][Oo][Rr][Ll][Ii][Ss][Tt]$") and is_sudo(msg) or text:match("^المنشئين") and is_sudo(msg) then
local hash =  'bot:creator:'..msg.chat_id_
	local list = database:smembers(hash)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>creators List:</b>\n\n"
else
  text = "🛅┇قائمة المنشئين  ،\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
end
for k,v in pairs(list) do
	local user_info = database:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text.."<b>|"..k.."|</b>~⪼(@"..username..")\n"
else
text = text.."<b>|"..k.."|</b>~⪼(<code>"..v.."</code>)\n"
		end
	end
	if #list == 0 then
	   if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>creator List is empty !</b>"
  else
text = "✖┇لايوجد منشئين"
end
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Bb][Aa][Nn][Ll][Ii][Ss][Tt]$") and is_mod(msg.sender_user_id_, msg.chat_id_) or text:match("^المحظورين$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
local hash =  'bot:banned:'..msg.chat_id_
	local list = database:smembers(hash)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>ban List:</b>\n\n"
else
  text = "⛔┇قائمة المحظورين  ،\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
end
for k,v in pairs(list) do
	local user_info = database:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text.."<b>|"..k.."|</b>~⪼(@"..username..")\n"
else
text = text.."<b>|"..k.."|</b>~⪼(<code>"..v.."</code>)\n"
		end
	end
	if #list == 0 then
	   if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>ban List is empty !</b>"
  else
text = "✖┇لايوجد محظورين"
end
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end

  if msg.content_.text_:match("^[Gg][Bb][Aa][Nn][Ll][Ii][Ss][Tt]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or msg.content_.text_:match("^قائمه العام$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local hash =  'bot:gbanned:'
local list = database:smembers(hash)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>Gban List:</b>\n\n"
else
  text = "⛔┇قائمة الحظر العام  ،\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
end
for k,v in pairs(list) do
local user_info = database:hgetall('user:'..v)
if user_info and user_info.username then
local username = user_info.username
text = text.."<b>|"..k.."|</b>~⪼(@"..username..")\n"
 else
  text = text.."<b>|"..k.."|</b>~⪼(<code>"..v.."</code>)\n"
end
end
if #list == 0 then
	   if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>Gban List is empty !</b>"
  else
text = "✖┇لايوجد محظورين عام"
end
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end

  if msg.content_.text_:match("^[Gg][Ss][Ii][Ll][Ee][Nn][Tt][Ll][Ii][Ss][Tt]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or msg.content_.text_:match("^المكتومين عام$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local hash =  'bot:gmuted:'
local list = database:smembers(hash)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>Gban List:</b>\n\n"
else
  text = "⛔┇قائمة الكتم العام  ،\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
end
for k,v in pairs(list) do
local user_info = database:hgetall('user:'..v)
if user_info and user_info.username then
local username = user_info.username
text = text.."<b>|"..k.."|</b>~⪼(@"..username..")\n"
 else
  text = text.."<b>|"..k.."|</b>~⪼(<code>"..v.."</code>)\n"
end
end
if #list == 0 then
	   if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>Gban List is empty !</b>"
  else
text = "✖┇لايوجد مكتومين عام"
end
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end

	-----------------------------------------------------------------------------------------------
if text:match("^[Ii][Dd]$") and msg.reply_to_message_id_ ~= 0 or text:match("^ايدي$") and msg.reply_to_message_id_ ~= 0 then
function id_by_reply(extra, result, success)
	  local user_msgs = database:get('user:msgs'..result.chat_id_..':'..result.sender_user_id_)
  send(msg.chat_id_, msg.id_, 1, "🎫┇الايدي ~⪼ (`"..result.sender_user_id_.."`)", 1, 'md')
  end
   getMessage(msg.chat_id_, msg.reply_to_message_id_,id_by_reply)
  end
  -----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('ايدي','id')
if text:match("^[Ii][Dd] @(.*)$") then
	local ap = {string.match(text, "^([Ii][Dd]) @(.*)$")}
	function id_by_username(extra, result, success)
	if result.id_ then
texts = '🎫┇الايدي ~⪼ ('..result.id_..')'
else
if database:get('bot:lang:'..msg.chat_id_) then
texts = '<code>User not found!</code>'
else
texts = '✖┇خطاء'
end
end
	   send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
end
	resolve_username(ap[2],id_by_username)
end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('جلب صوره','getpro')
if text:match("^getpro (%d+)$") and msg.reply_to_message_id_ == 0  then
		local pronumb = {string.match(text, "^(getpro) (%d+)$")}
local function gpro(extra, result, success)
--vardump(result)
   if pronumb[2] == '1' then
   if result.photos_[0] then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_)
   else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "You Have'nt Profile Photo!!", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇لا تملك صوره رقم <b>{1}</b> في حسابك", 1, 'html')
end
   end
   elseif pronumb[2] == '2' then
   if result.photos_[1] then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[1].sizes_[1].photo_.persistent_id_)
   else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "You Have'nt 2 Profile Photo!!", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇لا تملك صوره رقم <b>{2}</b> في حسابك", 1, 'html')
end
   end
   elseif pronumb[2] == '3' then
   if result.photos_[2] then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[2].sizes_[1].photo_.persistent_id_)
   else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "You Have'nt 3 Profile Photo!!", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇لا تملك صوره رقم <b>{3}</b> في حسابك", 1, 'html')
end
   end
   elseif pronumb[2] == '4' then
if result.photos_[3] then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[3].sizes_[1].photo_.persistent_id_)
   else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "You Have'nt 4 Profile Photo!!", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇لا تملك صوره رقم <b>{4}</b> في حسابك", 1, 'html')
end
   end
   elseif pronumb[2] == '5' then
   if result.photos_[4] then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[4].sizes_[1].photo_.persistent_id_)
   else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "You Have'nt 5 Profile Photo!!", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇لا تملك صوره رقم <b>{5}</b> في حسابك", 1, 'html')
end
   end
   elseif pronumb[2] == '6' then
   if result.photos_[5] then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[5].sizes_[1].photo_.persistent_id_)
   else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "You Have'nt 6 Profile Photo!!", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇لا تملك صوره رقم <b>{6}</b> في حسابك", 1, 'html')
end
   end
   elseif pronumb[2] == '7' then
   if result.photos_[6] then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[6].sizes_[1].photo_.persistent_id_)
   else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "You Have'nt 7 Profile Photo!!", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇لا تملك صوره رقم <b>{7}</b> في حسابك", 1, 'html')
end
   end
   elseif pronumb[2] == '8' then
   if result.photos_[7] then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[7].sizes_[1].photo_.persistent_id_)
   else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "You Have'nt 8 Profile Photo!!", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇لا تملك صوره رقم <b>{8}</b> في حسابك", 1, 'html')
end
   end
   elseif pronumb[2] == '9' then
   if result.photos_[8] then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[8].sizes_[1].photo_.persistent_id_)
   else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "You Have'nt 9 Profile Photo!!", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇لا تملك صوره رقم <b>{9}</b> في حسابك", 1, 'html')
end
   end
   elseif pronumb[2] == '10' then
   if result.photos_[9] then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[9].sizes_[1].photo_.persistent_id_)
   else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "_You Have'nt 10 Profile Photo!!_", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇لا تملك صوره رقم <b>{10}</b> في حسابك", 1, 'html')
end
   end
 else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "*I just can get last 10 profile photos!:(*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "✖┇لا تسطتيع جلب اكثر  <b>{10}</b> صوره \n ", 1, 'html')
end
   end
   end
   tdcli_function ({
ID = "GetUserProfilePhotos",
user_id_ = msg.sender_user_id_,
offset_ = 0,
limit_ = pronumb[2]
  }, gpro, nil)
	end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('وضع تكرار بالطرد','flood ban')
	if text:match("^[Ff][Ll][Oo][Oo][Dd] [Bb][Aa][Nn] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local floodmax = {string.match(text, "^([Ff][Ll][Oo][Oo][Dd] [Bb][Aa][Nn]) (%d+)$")}
	if tonumber(floodmax[2]) < 2 then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*Wrong number*,_range is  [2-99999]_', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '🔘┇ضع التكرار من *{2}* الى  *{99999}*', 1, 'md')
end
	else
database:set('flood:max:'..msg.chat_id_,floodmax[2])
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Flood has been set to_ *'..floodmax[2]..'*', 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '☑┇️تم  وضع التكرار بالطرد للعدد ~⪼  *{'..floodmax[2]..'}*', 1, 'md')
end
	end
end

local text = msg.content_.text_:gsub('وضع تكرار بالكتم','flood mute')
	if text:match("^[Ff][Ll][Oo][Oo][Dd] [Mm][Uu][Tt][Ee] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local floodmax = {string.match(text, "^([Ff][Ll][Oo][Oo][Dd] [Mm][Uu][Tt][Ee]) (%d+)$")}
	if tonumber(floodmax[2]) < 2 then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*Wrong number*,_range is  [2-99999]_', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '🔘┇ضع التكرار من *{2}* الى  *{99999}*', 1, 'md')
end
	else
database:set('flood:max:warn'..msg.chat_id_,floodmax[2])
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Flood Warn has been set to_ *'..floodmax[2]..'*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '☑┇️تم  وضع التكرار بالكتم للعدد ~⪼  *{'..floodmax[2]..'}*', 1, 'md')
end
	end
end
local text = msg.content_.text_:gsub('وضع تكرار بالمسح','flood del')
	if text:match("^[Ff][Ll][Oo][Oo][Dd] [Dd][Ee][Ll] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local floodmax = {string.match(text, "^([Ff][Ll][Oo][Oo][Dd] [Dd][Ee][Ll]) (%d+)$")}
	if tonumber(floodmax[2]) < 2 then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*Wrong number*,_range is  [2-99999]_', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '🔘┇ضع التكرار من *{2}* الى  *{99999}*', 1, 'md')
end
	else
database:set('flood:max:del'..msg.chat_id_,floodmax[2])
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Flood delete has been set to_ *'..floodmax[2]..'*', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '☑┇️تم  وضع بالمسح للعدد ~⪼  *{'..floodmax[2]..'}*', 1, 'md')
end
	end
end
local text = msg.content_.text_:gsub('وضع كلايش بالمسح','spam del')
if text:match("^[Ss][Pp][Aa][Mm] [Dd][Ee][Ll] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
local sensspam = {string.match(text, "^([Ss][Pp][Aa][Mm] [Dd][Ee][Ll]) (%d+)$")}
if tonumber(sensspam[2]) < 40 then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '*Wrong number*,_range is  [40-99999]_', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '🔘┇ضع العدد من *{40}* الى  *{99999}*', 1, 'md')
end
 else
database:set('bot:sens:spam'..msg.chat_id_,sensspam[2])
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Spam has been set to_ *'..sensspam[2]..'*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇️تم  وضع الكليشه بالمسح للعدد ~⪼  *{'..sensspam[2]..'}*', 1, 'md')
end
end
end
local text = msg.content_.text_:gsub('وضع كلايش بالتحذير','spam warn')
if text:match("^[Ss][Pp][Aa][Mm] [Ww][Aa][Rr][Nn] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
local sensspam = {string.match(text, "^([Ss][Pp][Aa][Mm] [Ww][Aa][Rr][Nn]) (%d+)$")}
if tonumber(sensspam[2]) < 40 then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '*Wrong number*,_range is  [40-99999]_', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '🔘┇ضع العدد من *{40}* الى  *{99999}*', 1, 'md')
end
 else
database:set('bot:sens:spam:warn'..msg.chat_id_,sensspam[2])
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Spam Warn has been set to_ *'..sensspam[2]..'*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇️تم  وضع الكليشه بالتحذير للعدد ~⪼  *{'..sensspam[2]..'}*', 1, 'md')
end
end
end

	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('وضع زمن التكرار','flood time')
	if text:match("^[Ff][Ll][Oo][Oo][Dd] [Tt][Ii][Mm][Ee] (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local floodt = {string.match(text, "^([Ff][Ll][Oo][Oo][Dd] [Tt][Ii][Mm][Ee]) (%d+)$")}
	if tonumber(floodt[2]) < 1 then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*Wrong number*,_range is  [2-99999]_', 1, 'md')
 else
send(msg.chat_id_, msg.id_, 1, '🔘┇ضع العدد من *{1}* الى  *{99999}*', 1, 'md')
end
	else
database:set('flood:time:'..msg.chat_id_,floodt[2])
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Flood has been set to_ *'..floodt[2]..'*', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '☑┇️تم  وضع الزمن التكرار للعدد ~⪼  *{'..floodt[2]..'}*', 1, 'md')
end
	end
	end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Ee][Tt][Ll][Ii][Nn][Kk]$") and is_mod(msg.sender_user_id_, msg.chat_id_) or text:match("^وضع رابط$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
   database:set("bot:group:link"..msg.chat_id_, 'Waiting For Link!\nPls Send Group Link')
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*Please Send Group Link Now!*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '📮┇قم بارسال الرابط  ليتم حفظه\n', 1, 'md')
end
	end
	-----------------------------------------------------------------------------------------------
	if text:match("^[Ll][Ii][Nn][Kk]$") or text:match("^الرابط$") then
	local link = database:get("bot:group:link"..msg.chat_id_)
	  if link then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '<b>Group link:</b>\n'..link, 1, 'html')
 else
  send(msg.chat_id_, msg.id_, 1, '\n📌┇[رابط المجموعه]('..link..')', 1, "md")
end
	  else
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*There is not link set yet. Please add one by #setlink .*', 1, 'md')
 else
  send(msg.chat_id_, msg.id_, 1, '🔘┇ ليتم حفظ الرابط ارسل { وضع الرابط } لحفظ الرابط الجديد', 1, 'md')
end
	  end
 	end
	-----------------------------------------------------------
	if text:match("^[Ww][Ll][Cc] [Oo][Nn]$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '#Done\nWelcome *Enabled* In This Supergroup.', 1, 'md')
		 database:set("bot:welcome"..msg.chat_id_,true)
	end
	if text:match("^[Ww][Ll][Cc] [Oo][Ff][Ff]$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '#Done\nWelcome *Disabled* In This Supergroup.', 1, 'md')
		 database:del("bot:welcome"..msg.chat_id_)
	end

	if text:match("^تفعيل الترحيب$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل الترحيب في المجموعه', 1, 'md')
		 database:set("bot:welcome"..msg.chat_id_,true)
	end
	if text:match("^تعطيل الترحيب$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '☑┇تم تعطيل الترحيب في المجموعه', 1, 'md')
		 database:del("bot:welcome"..msg.chat_id_)
	end

	if text:match("^[Ss][Ee][Tt] [Ww][Ll][Cc] (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local welcome = {string.match(text, "^([Ss][Ee][Tt] [Ww][Ll][Cc]) (.*)$")}
   send(msg.chat_id_, msg.id_, 1, '*Welcome Msg Has Been Saved!*\nWlc Text:\n\n`'..welcome[2]..'`', 1, 'md')
		 database:set('welcome:'..msg.chat_id_,welcome[2])
	end

	if text:match("^وضع ترحيب (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local welcome = {string.match(text, "^(وضع ترحيب) (.*)$")}
   send(msg.chat_id_, msg.id_, 1, '☑┇تم وضع ترحيب\n📜┇~⪼('..welcome[2]..')', 1, 'md')
		 database:set('welcome:'..msg.chat_id_,welcome[2])
	end

local text = msg.content_.text_:gsub('حذف الترحيب','del wlc')
	if text:match("^[Dd][Ee][Ll] [Ww][Ll][Cc]$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*Welcome Msg Has Been Deleted!*', 1, 'md')
 else
  send(msg.chat_id_, msg.id_, 1, '☑┇تم حذف الترحيب', 1, 'md')
end
		 database:del('welcome:'..msg.chat_id_)
	end

local text = msg.content_.text_:gsub('جلب الترحيب','get wlc')
	if text:match("^[Gg][Ee][Tt] [Ww][Ll][Cc]$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local wel = database:get('welcome:'..msg.chat_id_)
	if wel then
   send(msg.chat_id_, msg.id_, 1, '📜┇الترحيب\n~⪼('..wel..')', 1, 'md')
else
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, 'Welcome msg not saved!', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '✖┇لم يتم وضع ترحيب للمجموعه\n', 1, 'md')
end
	end
	end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('منع','bad')
	if text:match("^[Bb][Aa][Dd] (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local filters = {string.match(text, "^([Bb][Aa][Dd]) (.*)$")}
local name = string.sub(filters[2], 1, 50)
database:hset('bot:filters:'..msg.chat_id_, name, 'filtered')
if database:get('bot:lang:'..msg.chat_id_) then
		  send(msg.chat_id_, msg.id_, 1, "*New Word baded!*\n--> `"..name.."`", 1, 'md')
else
  		  send(msg.chat_id_, msg.id_, 1, "☑┇تم اضافتها لقائمه المنع️\n🔘┇{"..name.."}", 1, 'md')
end
	end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('الغاء منع','unbad')
	if text:match("^[Uu][Nn][Bb][Aa][Dd] (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local rws = {string.match(text, "^([Uu][Nn][Bb][Aa][Dd]) (.*)$")}
local name = string.sub(rws[2], 1, 50)
database:hdel('bot:filters:'..msg.chat_id_, rws[2])
if database:get('bot:lang:'..msg.chat_id_) then
		  send(msg.chat_id_, msg.id_, 1, "`"..rws[2].."` *Removed From baded List!*", 1, 'md')
else
  		  send(msg.chat_id_, msg.id_, 1, "☑┇تم حذفها من لقائمه المنع️\n🔘┇{"..rws[2].."}", 1, 'md')
end
	end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('ارسال','send')
	if text:match("^[Ss][Ee][Nn][Dd] (.*)$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
local gps = database:scard("bot:groups") or 0
local gpss = database:smembers("bot:groups") or 0
	local rws = {string.match(text, "^([Ss][Ee][Nn][Dd]) (.*)$")}
	for i=1, #gpss do
		  send(gpss[i], 0, 1, rws[2], 1, 'html')
  end
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*Done*\n_Your Msg Send to_ `'..gps..'` _Groups_', 1, 'md')
   else
send(msg.chat_id_, msg.id_, 1, '☑┇تم نشر الرساله في {'..gps..'}مجموعه ', 1, 'md')
end
	end

local text = msg.content_.text_:gsub('اذاعه','bc')
	if text:match("^bc (.*)$") and is_sudo(msg) then
	local ssss = {string.match(text, "^(bc) (.*)$")}
if not database:get('bot:bc:groups') then
local gps = database:scard("bot:groups") or 0
local gpss = database:smembers("bot:groups") or 0
	for i=1, #gpss do
		  send(gpss[i], 0, 1, ssss[2], 1, 'html')
  end
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*Done*\n_Your Msg Send to_ `'..gps..'` _Groups_', 1, 'md')
   else
send(msg.chat_id_, msg.id_, 1, '☑┇تم نشر الرساله في {'..gps..'}مجموعه ', 1, 'md')
end
else
 if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '*broadcast has been Disabled*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇ الاذاعه معطله ', 1, 'md')
end
end
	end

 local text = msg.content_.text_:gsub('كشف البوتات','bots')
if text:match("^[Bb][Oo][Tt][Ss]$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
   local txt = {string.match(text, "^[Bb][Oo][Tt][Ss]$")}
   local function cb(extra,result,success)
   local list = result.members_
if database:get('bot:lang:'..msg.chat_id_) then
  text = '<b>List Bots group</b> : \n\n'
  else
  text = '📊┇البوتات\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n'
  end
 local n = 0
   for k,v in pairs(list) do
 n = (n + 1)
   local user_info = database:hgetall('user:'..v.user_id_)
if user_info and user_info.username then
 local username = user_info.username
 text = text.."<b>|"..n.."|</b>~⪼(@"..username..")\n"
else
 text = text.."<b>|"..n.."|</b>~⪼(<code>"..v.user_id_.."</code>)\n"
end
   end
 send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
 end
bot.channel_get_bots(msg.chat_id_,cb)
 end
	-----------------------------------------------------------------------------------------------

if text:match("^[Gg][Rr][Oo][Uu][Pp][Ss]$") or text:match("^الكروبات$") and is_sudo(msg) then
local gpss = database:smembers("bot:groups") or 0
local gps = database:scard("bot:groups")
if database:get('bot:lang:'..msg.chat_id_) then
text = '*Groups* '..gps..'\n'
else
text = '📊┇عدد الكروبات ~⪼ ('..gps..')\n'
 end
 for i=1, #gpss do
local link = database:get("bot:group:link"..gpss[i])
if database:get('bot:lang:'..msg.chat_id_) then
text = text.."*|"..i.."|* ~⪼ "..gpss[i].."\n> [LINK GROUP]("..(link or  " ")..")\n"
else
text = text.."*|"..i.."|* ~⪼ "..gpss[i].."\n🔘┇ ~⪼ [رابط المجموعه]("..(link or  " ")..")\n"
 end
 end
  send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
 end

if  text:match("^[Mm][Ss][Gg]$") or text:match("^رسائلي$") and msg.reply_to_message_id_ == 0  then
local user_msgs = database:get('user:msgs'..msg.chat_id_..':'..msg.sender_user_id_)
if database:get('bot:lang:'..msg.chat_id_) then
 if not database:get('bot:id:mute'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "*Msgs : * `"..user_msgs.."`", 1, 'md')
else
  end
else
 if not database:get('bot:id:mute'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "📨┇عدد رسالئلك ~⪼ *{"..user_msgs.."}*", 1, 'md')
else
  end
end
	end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('قفل الكل بالثواني','lock all s')
  	if text:match("^[Ll][Oo][Cc][Kk] [Aa][Ll][Ll] [Ss] (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local mutept = {string.match(text, "^[Ll][Oo][Cc][Kk] [Aa][Ll][Ll] [Ss] (%d+)$")}
		database:setex('bot:muteall'..msg.chat_id_, tonumber(mutept[1]), true)
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Group muted for_ *'..mutept[1]..'* _seconds!_', 1, 'md')
 else
  send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الكل بالثواني ", 1, 'md')
end
	end

local text = msg.content_.text_:gsub('قفل الكل بالساعه','lock all h')
if text:match("^[Ll][Oo][Cc][Kk] [Aa][Ll][Ll] [Hh]  (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
  local mutept = {string.match(text, "^[Ll][Oo][Cc][Kk] [Aa][Ll][Ll] [Hh] (%d+)$")}
  local hour = string.gsub(mutept[1], 'h', '')
  local num1 = tonumber(hour) * 3600
  local num = tonumber(num1)
database:setex('bot:muteall'..msg.chat_id_, num, true)
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "> Lock all has been enable for "..mutept[1].." hours !", 'md')
 else
  send(msg.chat_id_, msg.id_, 1, "`• تم قفل كل الوسائط لمدة` "..mutept[1].." `ساعه` 🔐❌", 'md')
end
end
	-----------------------------------------------------------------------------------------------
  	if text:match("^[Ll][Oo][Cc][Kk] (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) or text:match("^قفل (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local mutept = {string.match(text, "^([Ll][Oo][Cc][Kk]) (.*)$")}
	local TSHAKE = {string.match(text, "^(قفل) (.*)$")}
local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
	 if mutept[2] == "edit"and is_owner(msg.sender_user_id_, msg.chat_id_) or TSHAKE[2] == "التعديل" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if not database:get('editmsg'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "_> Edit Has been_ *locked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التعديل"..lockwarn.." ", 1, 'md')
end
database:set('editmsg'..msg.chat_id_,'delmsg')
  else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Lock edit is already_ *locked*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التعديل"..lockwarn.." ", 1, 'md')
end
  end
end
end
  getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
 function keko333(extra,result,success)
  keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
  local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
  local lockban = "\n🚫┇خاصية ~⪼ الطرد"
  local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
 if mutept[2] == "bots" or TSHAKE[2] == "البوتات" then
  if not database:get('bot:bots:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "_> Bots Has been_ *locked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑️️┇تم قفل البوتات"..lockban.." ", 1, 'md')
end
database:set('bot:bots:mute'..msg.chat_id_,true)
  else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "_> Bots is Already_ *locked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل البوتات"..lockban.." ", 1, 'md')
end
  end
end
end
 getUser(msg.sender_user_id_, keko333)

  local keko_info = nil
 function keko333(extra,result,success)
  keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockban = "\n🚫┇خاصية ~⪼ طرد البوت والعضو"
  local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
 if mutept[2] == "bots ban" or TSHAKE[2] == "البوتات بالطرد" then
  if not database:get('bot:bots:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "_> Bots Has been_ *locked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑️️┇تم قفل البوتات بالطرد"..lockban.." ", 1, 'md')
end
database:set('bot:bots:ban'..msg.chat_id_,true)
  else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "_> Bots is Already_ *locked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل البوتات بالطرد"..lockban.." ", 1, 'md')
end
  end
end
end
 getUser(msg.sender_user_id_, keko333)

local keko_info = nil
function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
 local lockmute = "\n🗑┇خاصية ~⪼ المسح"
 local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
   local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
	  if mutept[2] == "flood ban" and is_owner(msg.sender_user_id_, msg.chat_id_) or TSHAKE[2] == "التكرار بالطرد" and is_owner(msg.sender_user_id_, msg.chat_id_) then
if database:get('anti-flood:'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '_> *Flood ban* has been *unlocked*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التكرار"..lockban.." ", 1, 'md')
end
database:del('anti-flood:'..msg.chat_id_)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> *Flood ban* is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التكرار"..lockban.." ", 1, 'md')
end
  end
end
  end
 getUser(msg.sender_user_id_, keko333)
local keko_info = nil
function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
 local lockmute = "\n🗑┇خاصية ~⪼ المسح"
 local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
   local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
	  if mutept[2] == "flood mute" and is_owner(msg.sender_user_id_, msg.chat_id_) or TSHAKE[2] == "التكرار بالكتم" and is_owner(msg.sender_user_id_, msg.chat_id_) then
if database:get('anti-flood:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '_> *Flood mute* has been *unlocked*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التكرار"..lockmute.." ", 1, 'md')
end
database:del('anti-flood:warn'..msg.chat_id_)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> *Flood mute* is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التكرار"..lockmute.." ", 1, 'md')
end
  end
  end
end
   getUser(msg.sender_user_id_, keko333)
local keko_info = nil
   function keko333(extra,result,success)
  keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
 local lockban = "\n🚫┇خاصية ~⪼ الطرد"
  local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
	  if mutept[2] == "flood del" and is_owner(msg.sender_user_id_, msg.chat_id_) or TSHAKE[2] == "التكرار بالمسح" and is_owner(msg.sender_user_id_, msg.chat_id_) then
if database:get('anti-flood:del'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '_> *Flood del* has been *unlocked*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التكرار"..lockmute.." ", 1, 'md')
end
database:del('anti-flood:del'..msg.chat_id_)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> *Flood del* is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التكرار"..lockmute.." ", 1, 'md')
end
  end
end
  end
 getUser(msg.sender_user_id_, keko333)
local keko_info = nil
function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
 local lockmute = "\n🗑┇خاصية ~⪼ المسح"
 local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
   local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "pin" and is_owner(msg.sender_user_id_, msg.chat_id_) or TSHAKE[2] == "التثبيت" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if not database:get('bot:pin:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "_> Pin Has been_ *locked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التثبيت"..lockmute.." ", 1, 'md')
end
database:set('bot:pin:mute'..msg.chat_id_,true)
  else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "_> Pin is Already_ *locked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التثبيت"..lockmute.." ", 1, 'md')
end
  end
end
  end
 getUser(msg.sender_user_id_, keko333)
local keko_info = nil
function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
 local lockmute = "\n🗑┇خاصية ~⪼ المسح"
 local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
   local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "pin warn" and is_owner(msg.sender_user_id_, msg.chat_id_) or TSHAKE[2] == "التثبيت بالتحذير" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if not database:get('bot:pin:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "_> Pin warn Has been_ *locked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التثبيت"..lockwarn.." ", 1, 'md')
end
database:set('bot:pin:warn'..msg.chat_id_,true)
  else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "_> Pin warn is Already_ *locked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التثبيت"..lockwarn.." ", 1, 'md')
end
  end
  end
end
local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "media" or TSHAKE[2] == "الوسائط" then
	  if not database:get('bot:muteall'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> mute all has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل كل الوسائط"..lockmute.." ", 1, 'md')
end
   database:set('bot:muteall'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> mute all is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل كل الوسائط"..lockmute.." ", 1, 'md')
end
end
end
end
  getUser(msg.sender_user_id_, keko333)
local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "media warn" or TSHAKE[2] == "الوسائط بالتحذير" then
	  if not database:get('bot:muteallwarn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> mute all warn has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل كل الوسائط"..lockwarn.." ", 1, 'md')
end
   database:set('bot:muteallwarn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> mute all warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل كل الوسائط"..lockwarn.." ", 1, 'md')
end
end
end
  end
getUser(msg.sender_user_id_, keko333)

local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "media ban" or TSHAKE[2] == "الوسائط بالطرد" then
	  if not database:get('bot:muteallban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> mute all ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل كل الوسائط"..lockban.." ", 1, 'md')
end
   database:set('bot:muteallban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> mute all ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل كل الوسائط"..lockban.." ", 1, 'md')
end
end

  end
end
getUser(msg.sender_user_id_, keko333)
local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "text" or TSHAKE[2] == "الدردشه" then
	  if not database:get('bot:text:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Text has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الدردشه"..lockmute.." ", 1, 'md')
end
   database:set('bot:text:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> Text is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الدردشه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)

local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "text ban" or TSHAKE[2] == "الدردشه بالطرد" then
	  if not database:get('bot:text:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Text ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل كل الدردشه"..lockban.." ", 1, 'md')
end
   database:set('bot:text:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> Text ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل كل الدردشه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "text warn" or TSHAKE[2] == "الدردشه بالتحذير" then
	  if not database:get('bot:text:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Text ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل كل الدردشه"..lockwarn.." ", 1, 'md')
end
   database:set('bot:text:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> Text warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل كل الدردشه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "inline" or TSHAKE[2] == "الانلاين" then
	  if not database:get('bot:inline:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> inline has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل كل الانلاين"..lockmute.." ", 1, 'md')
end
   database:set('bot:inline:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> inline is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل كل الانلاين"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "inline ban" or TSHAKE[2] == "الانلاين بالطرد" then
	  if not database:get('bot:inline:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> inline ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل كل الانلاين"..lockban.." ", 1, 'md')
end
   database:set('bot:inline:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> inline ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل كل الانلاين"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "inline warn" or TSHAKE[2] == "الانلاين بالتحذير" then
	  if not database:get('bot:inline:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> inline ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇ تم قفل كل الانلاين"..lockban.." ", 1, 'md')
end
   database:set('bot:inline:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> inline warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل كل الانلاين"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "video note" or TSHAKE[2] == "بصمه الفيديو" then
	  if not database:get('bot:note:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video note has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل بصمه الفيديو"..lockmute.." ", 1, 'md')
end
   database:set('bot:note:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video note is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل بصمه الفيديو"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "video note ban" or TSHAKE[2] == "بصمه الفيديو بالطرد" then
	  if not database:get('bot:note:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video note ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل بصمه الفيديو"..lockban.." ", 1, 'md')
end
   database:set('bot:note:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video note ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل بصمه الفيديو"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "video note warn" or TSHAKE[2] == "بصمه الفيديو بالتحذير" then
	  if not database:get('bot:note:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video note ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇ تم قفل بصمه الفيديو"..lockban.." ", 1, 'md')
end
   database:set('bot:note:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video note warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل بصمه الفيديو"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"

if mutept[2] == "photo" or TSHAKE[2] == "الصور" then
	  if not database:get('bot:photo:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> photo has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الصور"..lockmute.." ", 1, 'md')
end
   database:set('bot:photo:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> photo is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الصور"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "photo ban" or TSHAKE[2] == "الصور بالطرد" then
	  if not database:get('bot:photo:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> photo ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الصور"..lockban.." ", 1, 'md')
end
   database:set('bot:photo:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> photo ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الصور"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "photo warn" or TSHAKE[2] == "الصور بالتحذير" then
	  if not database:get('bot:photo:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> photo ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الصور"..lockwarn.." ", 1, 'md')
end
   database:set('bot:photo:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> photo warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الصور"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "video" or TSHAKE[2] == "الفيديو" then
	  if not database:get('bot:video:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الفيديو"..lockmute.." ", 1, 'md')
end
   database:set('bot:video:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بفعل تم قفل الفيديو"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "video ban" or TSHAKE[2] == "الفيديو بالطرد" then
	  if not database:get('bot:video:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الفيديو"..lockban.." ", 1, 'md')
end
   database:set('bot:video:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الفيديو"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "\n💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "video warn" or TSHAKE[2] == "الفيديو بالتحذير" then
	  if not database:get('bot:video:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الفيديو"..lockwarn.." ", 1, 'md')
end
   database:set('bot:video:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الفيديو"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "gif" or TSHAKE[2] == "المتحركه" then
	  if not database:get('bot:gifs:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> gifs has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل المتحركه"..lockmute.." ", 1, 'md')
end
   database:set('bot:gifs:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> gifs is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل المتحركه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "gif ban" or TSHAKE[2] == "المتحركه بالطرد" then
	  if not database:get('bot:gifs:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> gifs ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل المتحركه"..lockban.." ", 1, 'md')
end
   database:set('bot:gifs:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> gifs ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل المتحركه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "gif warn" or TSHAKE[2] == "المتحركه بالتحذير" then
	  if not database:get('bot:gifs:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> gifs ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل المتحركه"..lockwarn.." ", 1, 'md')
end
   database:set('bot:gifs:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> gifs warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بلفعل تم قفل المتحركه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "\n💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "music" or TSHAKE[2] == "الاغاني" then
	  if not database:get('bot:music:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> music has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الاغاني"..lockmute.." ", 1, 'md')
end
   database:set('bot:music:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> music is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الاغاني"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "music ban" or TSHAKE[2] == "الاغاني بالطرد" then
	  if not database:get('bot:music:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> music ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الاغاني"..lockban.." ", 1, 'md')
end
   database:set('bot:music:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> music ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الاغاني"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "music warn" or TSHAKE[2] == "الاغاني بالتحذير" then
	  if not database:get('bot:music:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> music ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الاغاني"..lockwarn.." ", 1, 'md')
end
   database:set('bot:music:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> music warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الاغاني"..lockwarn.." ", 1, 'md')
end
end
end
end
   getUser(msg.sender_user_id_, keko333)
local keko_info = nil
function keko333(extra,result,success)
 keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
   local lockmute = "\n🗑┇خاصية ~⪼ المسح"
   local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
   local lockban = "\n🚫┇خاصية ~⪼ الطرد"
   local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "voice" or TSHAKE[2] == "الصوت" then
	  if not database:get('bot:voice:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> voice has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الصوت"..lockmute.." ", 1, 'md')
end
   database:set('bot:voice:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> voice is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الصوت"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "voice ban" or TSHAKE[2] == "الصوت بالطرد" then
	  if not database:get('bot:voice:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> voice ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الصوت"..lockban.." ", 1, 'md')
end
   database:set('bot:voice:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> voice ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الصوت"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "voice warn" or TSHAKE[2] == "الصوت بالتحذير" then
	  if not database:get('bot:voice:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> voice ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الصوت"..lockwarn.." ", 1, 'md')
end
   database:set('bot:voice:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> voice warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الصوت"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "links" or TSHAKE[2] == "الروابط" then
	  if not database:get('bot:links:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> links has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الروابط"..lockmute.." ", 1, 'md')
end
   database:set('bot:links:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> links is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الروابط"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "links ban" or TSHAKE[2] == "الروابط بالطرد" then
	  if not database:get('bot:links:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> links ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الروابط"..lockban.." ", 1, 'md')
end
   database:set('bot:links:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> links ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الروابط"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
local keko_info = nil
  function keko333(extra,result,success)
   keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
   local lockmute = "\n🗑┇خاصية ~⪼ المسح"
   local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
   local lockban = "\n🚫┇خاصية ~⪼ الطرد"
   local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"

if mutept[2] == "links warn" or TSHAKE[2] == "الروابط بالتحذير" then
	  if not database:get('bot:links:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> links ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الروابط"..lockwarn.." ", 1, 'md')
end
   database:set('bot:links:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> links warn is already_ *locked*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الروابط"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "location" or TSHAKE[2] == "الشبكات" then
	  if not database:get('bot:location:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> location has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الشبكات"..lockmute.." ", 1, 'md')
end
   database:set('bot:location:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> location is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الشبكات"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\nVخاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "location ban" or TSHAKE[2] == "الشبكات بالطرد" then
	  if not database:get('bot:location:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> location ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الشبكات"..lockban.." ", 1, 'md')
end
   database:set('bot:location:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> location ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الشبكاتب"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "location warn" or TSHAKE[2] == "الشبكات بالتحذير" then
	  if not database:get('bot:location:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> location ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الشبكات"..lockwarn.." ", 1, 'md')
end
   database:set('bot:location:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> location warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الشبكات"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "tag" or TSHAKE[2] == "المعرف" then
	  if not database:get('bot:tag:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> tag has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل المعرف"..lockmute.." ", 1, 'md')
end
   database:set('bot:tag:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> tag is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل المعرف"..lockmute.." ", 1, 'md')
end
end
end
end
   getUser(msg.sender_user_id_, keko333)
local keko_info = nil
function keko333(extra,result,success)
 keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
   local lockmute = "\n🗑┇خاصية ~⪼ المسح"
   local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
   local lockban = "\n🚫┇خاصية ~⪼ الطرد"
   local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "tag ban" or TSHAKE[2] == "المعرف بالطرد" then
	  if not database:get('bot:tag:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> tag ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل المعرف"..lockban.." ", 1, 'md')
end
   database:set('bot:tag:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> tag ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل المعرف"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "tag warn" or TSHAKE[2] == "المعرف بالتحذير" then
	  if not database:get('bot:tag:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> tag ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل المعرف"..lockwarn.." ", 1, 'md')
end
   database:set('bot:tag:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> tag warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل المعرف"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "hashtag" or TSHAKE[2] == "التاك" then
	  if not database:get('bot:hashtag:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> hashtag has been_ *Locked*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التاك"..lockmute.." ", 1, 'md')
end
   database:set('bot:hashtag:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> hashtag is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التاك"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "hashtag ban" or TSHAKE[2] == "التاك بالطرد" then
	  if not database:get('bot:hashtag:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> hashtag ban has been_ *Locked*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التاك"..lockban.." ", 1, 'md')
end
   database:set('bot:hashtag:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> hashtag ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التاك"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "hashtag warn" or TSHAKE[2] == "التاك بالتحذير" then
	  if not database:get('bot:hashtag:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> hashtag ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التاك"..lockwarn.." ", 1, 'md')
end
   database:set('bot:hashtag:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> hashtag warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇☑┇بالفعل تم قفل التاك"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "contact" or TSHAKE[2] == "الجهات" then
	  if not database:get('bot:contact:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> contact has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الجهات"..lockmute.." ", 1, 'md')
end
   database:set('bot:contact:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> contact is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الجهات"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "contact ban" or TSHAKE[2] == "الجهات بالطرد" then
	  if not database:get('bot:contact:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> contact ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الجهات"..lockban.." ", 1, 'md')
end
   database:set('bot:contact:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> contact ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الجهات"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "contact warn" or TSHAKE[2] == "الجهات بالتحذير" then
	  if not database:get('bot:contact:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> contact ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الجهات"..lockwarn.." ", 1, 'md')
end
   database:set('bot:contact:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> contact warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الجهات"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "webpage" or TSHAKE[2] == "المواقع" then
	  if not database:get('bot:webpage:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> webpage has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل المواقع"..lockmute.." ", 1, 'md')
end
   database:set('bot:webpage:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> webpage is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل المواقع"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "webpage ban" or TSHAKE[2] == "المواقع بالطرد" then
	  if not database:get('bot:webpage:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> webpage ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل المواقع"..lockban.." ", 1, 'md')
end
   database:set('bot:webpage:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> webpage ban is already_ *Locked*', 1, 'md')
else
   ssend(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل المواقع"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "webpage warn" or TSHAKE[2] == "المواقع بالتحذير" then
	  if not database:get('bot:webpage:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> webpage ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل المواقع"..lockwarn.." ", 1, 'md')
end
   database:set('bot:webpage:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> webpage warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل المواقع"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
local keko_info = nil
 function keko333(extra,result,success)
  keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "arabic" or TSHAKE[2] == "العربيه" then
	  if not database:get('bot:arabic:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> arabic has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل العربيه"..lockmute.." ", 1, 'md')
end
   database:set('bot:arabic:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> arabic is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل العربيه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "arabic ban" or TSHAKE[2] == "العربيه بالطرد" then
	  if not database:get('bot:arabic:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> arabic ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل العربيه"..lockban.." ", 1, 'md')
end
   database:set('bot:arabic:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> arabic ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل العربيه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "arabic warn" or TSHAKE[2] == "العربيه بالتحذير" then
	  if not database:get('bot:arabic:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> arabic ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل العربيه"..lockwarn.." ", 1, 'md')
end
   database:set('bot:arabic:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> arabic warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل العربيه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "english" or TSHAKE[2] == "الانكليزيه" then
	  if not database:get('bot:english:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> english has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الانكليزيه"..lockmute.." ", 1, 'md')
end
   database:set('bot:english:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> english is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الانكليزيه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "english ban" or TSHAKE[2] == "الانكليزيه بالطرد" then
	  if not database:get('bot:text:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> english ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الانكليزيه"..lockban.." ", 1, 'md')
end
   database:set('bot:english:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> english ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الانكليزيه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "english warn" or TSHAKE[2] == "الانكليزيه بالتحذير" then
	  if not database:get('bot:english:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> english ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الانكليزيه"..lockwarn.." ", 1, 'md')
end
   database:set('bot:english:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> english warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الانكليزيه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "spam del" or TSHAKE[2] == "الكلايش" then
	  if not database:get('bot:spam:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> spam has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الكلايش"..lockmute.." ", 1, 'md')
end
   database:set('bot:spam:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> spam is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الكلايش"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "\n💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "spam warn" or TSHAKE[2] == "الكلايش بالتحذير" then
	  if not database:get('bot:spam:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> spam ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الكلايش"..lockwarn.." ", 1, 'md')
end
   database:set('bot:spam:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> spam warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الكلايش"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "\n💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "sticker" or TSHAKE[2] == "الملصقات" then
	  if not database:get('bot:sticker:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> sticker has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الملصقات"..lockmute.." ", 1, 'md')
end
   database:set('bot:sticker:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> sticker is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الملصقات"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "sticker ban" or TSHAKE[2] == "الملصقات بالطرد" then
	  if not database:get('bot:sticker:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> sticker ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الملصقات"..lockban.." ", 1, 'md')
end
   database:set('bot:sticker:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> sticker ban is already_ *Locked*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الملصقات"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "sticker warn" or TSHAKE[2] == "الملصقات بالتحذير" then
	  if not database:get('bot:sticker:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> sticker ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الملصقات"..lockwarn.." ", 1, 'md')
end
   database:set('bot:sticker:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> sticker warn is already_ *Locked*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الملصقات"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
local keko_info = nil
 function keko333(extra,result,success)
  keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "file" or TSHAKE[2] == "الملفات" then
	  if not database:get('bot:document:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> file has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الملفات"..lockmute.." ", 1, 'md')
end
   database:set('bot:document:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> file is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الملفات"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "file ban" or TSHAKE[2] == "الملفات بالطرد" then
	  if not database:get('bot:document:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> file ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الملفات"..lockban.." ", 1, 'md')
end
   database:set('bot:document:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> file ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الملفات"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "file warn" or TSHAKE[2] == "الملفات بالتحذير" then
	  if not database:get('bot:document:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> file ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الملفات"..lockwarn.." ", 1, 'md')
end
   database:set('bot:document:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> file warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الملفات"..lockwarn.." ", 1, 'md')
end
end
  end
  end
  getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
  local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
  local lockban = "\n🚫┇خاصية ~⪼ الطرد"
  local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"

if mutept[2] == "markdown" or TSHAKE[2] == "الماركدون" then
	  if not database:get('bot:markdown:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> markdown has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الماركدون"..lockmute.." ", 1, 'md')
end
   database:set('bot:markdown:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> markdown is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الماركدون"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "markdown ban" or TSHAKE[2] == "الماركدون بالطرد" then
	  if not database:get('bot:markdown:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> markdown ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الماركدون"..lockban.." ", 1, 'md')
end
   database:set('bot:markdown:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> markdown ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الماركدون"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "markdown warn" or TSHAKE[2] == "الماركدون بالتحذير" then
	  if not database:get('bot:markdown:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> markdown ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الماركدون"..lockwarn.." ", 1, 'md')
end
   database:set('bot:markdown:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> markdown warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الماركدون"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
local keko_info = nil
 function keko333(extra,result,success)
  keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"

	  if mutept[2] == "service" or TSHAKE[2] == "الاشعارات" then
	  if not database:get('bot:tgservice:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> tgservice has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الماركدون"..lockmute.." ", 1, 'md')
end
   database:set('bot:tgservice:mute'..msg.chat_id_,true)
 else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> tgservice is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الماركدون"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "fwd" or TSHAKE[2] == "التوجيه" then
	  if not database:get('bot:forward:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> forward has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التوجيه"..lockmute.." ", 1, 'md')
end
   database:set('bot:forward:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> forward is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التوجيه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "fwd ban" or TSHAKE[2] == "التوجيه بالطرد" then
	  if not database:get('bot:forward:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> forward ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التوجيه"..lockban.." ", 1, 'md')
end
   database:set('bot:forward:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> forward ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التوجيه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "fwd warn" or TSHAKE[2] == "التوجيه بالتحذير" then
	  if not database:get('bot:forward:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> forward ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل التوجيه"..lockwarn.." ", 1, 'md')
end
   database:set('bot:forward:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> forward warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل التوجيه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(]"..keko_info.."[)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "cmd" or TSHAKE[2] == "الشارحه" then
	  if not database:get('bot:cmd:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> cmd has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الشارحه"..lockmute.." ", 1, 'md')
end
   database:set('bot:cmd:mute'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> cmd is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الشارحه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(]"..keko_info.."[)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "cmd ban" or TSHAKE[2] == "الشارحه بالطرد" then
	  if not database:get('bot:cmd:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> cmd ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الشارحه"..lockban.." ", 1, 'md')
end
   database:set('bot:cmd:ban'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> cmd ban is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الشارحه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
   function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(]"..keko_info.."[)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if mutept[2] == "cmd warn" or TSHAKE[2] == "الشارحه بالتحذير" then
	  if not database:get('bot:cmd:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> cmd ban has been_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم قفل الشارحه"..lockwarn.." ", 1, 'md')
end
   database:set('bot:cmd:warn'..msg.chat_id_,true)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> cmd warn is already_ *Locked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم قفل الشارحه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
	end
	-----------------------------------------------------------------------------------------------
  	if text:match("^[Uu][Nn][Ll][Oo][Cc][Kk] (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) or text:match("^فتح (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local unmutept = {string.match(text, "^([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$")}
	local UNTSHAKE = {string.match(text, "^(فتح) (.*)$")}
	local keko_info = nil
function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "edit" and is_owner(msg.sender_user_id_, msg.chat_id_) or UNTSHAKE[2] == "التعديل" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if database:get('editmsg'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> Edit Has been_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح التعديل"..lockwarn.." ", 1, 'md')
end
database:del('editmsg'..msg.chat_id_)
  else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Lock edit is already_ *Unlocked*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح التعديل"..lockwarn.." ", 1, 'md')
end
  end
end
  end
getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
 function keko333(extra,result,success)
  keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
   local lockban = "\n🚫┇خاصية ~⪼ الطرد"
  local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "bots" or UNTSHAKE[2] == "البوتات" then
  if database:get('bot:bots:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> Bots Has been_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح البوتات"..lockban.." ", 1, 'md')
end
database:del('bot:bots:mute'..msg.chat_id_)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> Bots is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح البوتات"..lockban.." ", 1, 'md')
end
  end
end
  end
  getUser(msg.sender_user_id_, keko333)
   local keko_info = nil
function keko333(extra,result,success)
 keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
   local lockban = "\n🚫┇خاصية ~⪼ طرد البوت والعضو"
   local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "bots ban" or UNTSHAKE[2] == "البوتات بالطرد" then
  if database:get('bot:bots:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> Bots ban Has been_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح البوتات"..lockban.." ", 1, 'md')
end
database:del('bot:bots:ban'..msg.chat_id_)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> Bots ban is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح البوتات"..lockban.." ", 1, 'md')
end
  end
end
  end
  getUser(msg.sender_user_id_, keko333)

local keko_info = nil
 function keko333(extra,result,success)
  keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
 local lockmute = "\n🗑┇خاصية ~⪼ المسح"
 local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
 local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
	  if unmutept[2] == "flood ban" and is_owner(msg.sender_user_id_, msg.chat_id_) or UNTSHAKE[2] == "التكرار بالطرد" and is_owner(msg.sender_user_id_, msg.chat_id_) then
if not database:get('anti-flood:'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '_> *Flood ban* has been *unlocked*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح التكرار"..lockban.." ", 1, 'md')
end
 database:set('anti-flood:'..msg.chat_id_,true)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> *Flood ban* is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح التكرار"..lockban.." ", 1, 'md')
end
  end
end
  end
   getUser(msg.sender_user_id_, keko333)


local keko_info = nil
 function keko333(extra,result,success)
  keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
 local lockmute = "\n🗑┇خاصية ~⪼ {الكتم, الطرد, المسح}"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
	  if unmutept[2] == "flood all" and is_owner(msg.sender_user_id_, msg.chat_id_) or UNTSHAKE[2] == "التكرار" and is_owner(msg.sender_user_id_, msg.chat_id_) then
if not database:get('anti-flood:'..msg.chat_id_) then
if not database:get('anti-flood:warn'..msg.chat_id_) then
if not database:get('anti-flood:del'..msg.chat_id_) then

if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '_> *Flood ban* has been *unlocked*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح التكرار"..lockmute.." ", 1, 'md')
end

 database:set('anti-flood:'..msg.chat_id_,true)
 database:set('anti-flood:warn'..msg.chat_id_,true)
 database:set('anti-flood:del'..msg.chat_id_,true)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> *Flood ban* is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح التكرار"..lockmute.." ", 1, 'md')
end
  end
end
  end
  end
  end

   getUser(msg.sender_user_id_, keko333)

 local keko_info = nil
  function keko333(extra,result,success)
   keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ الكتم"
  local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
  local lockban = "\n🚫┇خاصية ~⪼ الطرد"
 local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
	  if unmutept[2] == "flood mute" and is_owner(msg.sender_user_id_, msg.chat_id_) or UNTSHAKE[2] == "التكرار بالكتم" and is_owner(msg.sender_user_id_, msg.chat_id_) then
if not database:get('anti-flood:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '_> *Flood mute* has been *unlocked*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇ تم فتح التكرار"..lockmute.." ", 1, 'md')
end
 database:set('anti-flood:warn'..msg.chat_id_,true)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> *Flood mute* is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح التكرار"..lockmute.." ", 1, 'md')
end
  end
  end
end
getUser(msg.sender_user_id_, keko333)

   local keko_info = nil
function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
   local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
	  if unmutept[2] == "flood del" and is_owner(msg.sender_user_id_, msg.chat_id_) or UNTSHAKE[2] == "التكرار بالمسح" and is_owner(msg.sender_user_id_, msg.chat_id_) then
if not database:get('anti-flood:del'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '_> *Flood del* has been *unlocked*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇ تم فتح التكرار"..lockmute.." ", 1, 'md')
end
 database:set('anti-flood:del'..msg.chat_id_,true)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> *Flood del* is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇ بالفعل تم فتح التكرار"..lockmute.." ", 1, 'md')
end
  end
end
   end
   getUser(msg.sender_user_id_, keko333)
local keko_info = nil
function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
   local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "pin" and is_owner(msg.sender_user_id_, msg.chat_id_) or UNTSHAKE[2] == "التثبيت" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:pin:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> Pin Has been_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇ تم فتح التثبيت"..lockmute.." ", 1, 'md')
end
database:del('bot:pin:mute'..msg.chat_id_)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> Pin is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇ بالفعل تم فتح التثبيت"..lockmute.." ", 1, 'md')
end
  end
end
  end
  getUser(msg.sender_user_id_, keko333)
  local keko_info = nil
  function keko333(extra,result,success)
 keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
 local lockmute = "\n🗑┇خاصية ~⪼ المسح"
 local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
 local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "pin warn" and is_owner(msg.sender_user_id_, msg.chat_id_) or UNTSHAKE[2] == "التثبيت بالتحذير" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:pin:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> Pin warn Has been_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇ تم فتح التثبيت"..lockwarn.." ", 1, 'md')
end
database:del('bot:pin:warn'..msg.chat_id_)
  else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, "_> Pin warn is Already_ *Unlocked*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇ بالفعل تم فتح التثبيت"..lockwarn.." ", 1, 'md')
end
  end

  end
end
getUser(msg.sender_user_id_, keko333)
	local keko_info = nil
 function keko333(extra,result,success)
  keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "media" or UNTSHAKE[2] == "الوسائط" then
	  if database:get('bot:muteall'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> mute all has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح كل الوسائط"..lockmute.." ", 1, 'md')
end
   database:del('bot:muteall'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> mute all is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح كل الوسائط"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
function keko333(extra,result,success)
   keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "media warn" or UNTSHAKE[2] == "الوسائط بالتحذير" then
	  if database:get('bot:muteallwarn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> mute all warn has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح كل الوسائط"..lockwarn.." ", 1, 'md')
end
   database:del('bot:muteallwarn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> mute all warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح كل الوسائط"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "media ban" or UNTSHAKE[2] == "الوسائط بالطرد" then
	  if database:get('bot:muteallban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> mute all ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح كل الوسائط"..lockban.." ", 1, 'md')
end
   database:del('bot:muteallban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> mute all ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح كل الوسائط"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "text" or UNTSHAKE[2] == "الدردشه" then
	  if database:get('bot:text:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Text has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الدردشه"..lockmute.." ", 1, 'md')
end
   database:del('bot:text:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> Text is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الدردشه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "text ban" or UNTSHAKE[2] == "الدردشه بالطرد" then
	  if database:get('bot:text:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Text ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الدردشه"..lockban.." ", 1, 'md')
end
   database:del('bot:text:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> Text ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الدردشه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "text warn" or UNTSHAKE[2] == "الدردشه بالتحذير" then
	  if database:get('bot:text:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> Text ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الدردشه"..lockwarn.." ", 1, 'md')
end
   database:del('bot:text:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> Text warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الدردشه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "video note" or UNTSHAKE[2] == "بصمه الفيديو" then
	  if database:get('bot:note:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video note has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح بصمه الفيديو"..lockmute.." ", 1, 'md')
end
   database:del('bot:note:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video note is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح بصمه الفيديو"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "video note ban" or UNTSHAKE[2] == "بصمه الفيديو بالطرد" then
	  if database:get('bot:note:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video note ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح بصمه الفيديو"..lockban.." ", 1, 'md')
end
   database:del('bot:note:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video note ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح بصمه الفيديو"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "video note warn" or UNTSHAKE[2] == "بصمه الفيديو بالتحذير" then
	  if database:get('bot:note:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video note ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح بصمه الفيديو"..lockwarn.." ", 1, 'md')
end
   database:del('bot:note:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video note warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح بصمه الفيديو"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "inline" or UNTSHAKE[2] == "الانلاين" then
	  if database:get('bot:inline:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> inline has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇☑┇تم فتح الانلاين"..lockmute.." ", 1, 'md')
end
   database:del('bot:inline:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> inline is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الانلاين"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "inline ban" or UNTSHAKE[2] == "الانلاين بالطرد" then
	  if database:get('bot:inline:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> inline ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الانلاين"..lockban.." ", 1, 'md')
end
   database:del('bot:inline:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> inline ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الانلاين"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "inline warn" or UNTSHAKE[2] == "الانلاين بالتحذير" then
	  if database:get('bot:inline:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> inline ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الانلاين"..lockwarn.." ", 1, 'md')
end
   database:del('bot:inline:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> inline warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الانلاين"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "photo" or UNTSHAKE[2] == "الصور" then
	  if database:get('bot:photo:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> photo has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الصور"..lockmute.." ", 1, 'md')
end
   database:del('bot:photo:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> photo is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الصور"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "photo ban" or UNTSHAKE[2] == "الصور بالطرد" then
	  if database:get('bot:photo:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> photo ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇☑┇تم فتح الصور"..lockban.." ", 1, 'md')
end
   database:del('bot:photo:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> photo ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الصور"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "photo warn" or UNTSHAKE[2] == "الصور بالتحذير" then
	  if database:get('bot:photo:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> photo ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الصور"..lockban.." ", 1, 'md')
end
   database:del('bot:photo:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> photo warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الصور"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "video" or UNTSHAKE[2] == "الفيديو" then
	  if database:get('bot:video:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الفيديو"..lockmute.." ", 1, 'md')
end
   database:del('bot:video:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الفيديو"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "video ban" or UNTSHAKE[2] == "الفيديو بالطرد" then
	  if database:get('bot:video:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الفيديو"..lockban.." ", 1, 'md')
end
   database:del('bot:video:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الفيديو"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "video warn" or UNTSHAKE[2] == "الفيديو بالتحذير" then
	  if database:get('bot:video:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> video ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الفيديو"..lockwarn.." ", 1, 'md')
end
   database:del('bot:video:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> video warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الفيديو"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "gif" or UNTSHAKE[2] == "المتحركه" then
	  if database:get('bot:gifs:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> gifs has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح المتحركه"..lockmute.." ", 1, 'md')
end
   database:del('bot:gifs:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> gifs is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح المتحركه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "gif ban" or UNTSHAKE[2] == "المتحركه بالطرد" then
	  if database:get('bot:gifs:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> gifs ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح المتحركه"..lockban.." ", 1, 'md')
end
   database:del('bot:gifs:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> gifs ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح المتحركه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "\n💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "gif warn" or UNTSHAKE[2] == "المتحركه بالتحذير" then
	  if database:get('bot:gifs:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> gifs ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح المتحركه"..lockwarn.." ", 1, 'md')
end
   database:del('bot:gifs:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> gifs warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح المتحركه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = " \n💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "music" or UNTSHAKE[2] == "الاغاني" then
	  if database:get('bot:music:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> music has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الاغاني"..lockmute.." ", 1, 'md')
end
   database:del('bot:music:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> music is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الاغاني"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "music ban" or UNTSHAKE[2] == "الاغاني بالطرد" then
	  if database:get('bot:music:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> music ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الاغاني"..lockban.." ", 1, 'md')
end
   database:del('bot:music:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> music ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الاغاني"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "music warn" or UNTSHAKE[2] == "الاغاني بالتحذير" then
	  if database:get('bot:music:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> music ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الاغاني"..lockwarn.." ", 1, 'md')
end
   database:del('bot:music:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> music warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الاغاني"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "\n💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "voice" or UNTSHAKE[2] == "الصوت" then
	  if database:get('bot:voice:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> voice has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الصوت"..lockmute.." ", 1, 'md')
end
   database:del('bot:voice:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> voice is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الصوت"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "voice ban" or UNTSHAKE[2] == "الصوت بالطرد" then
	  if database:get('bot:voice:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> voice ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الصوت"..lockban.." ", 1, 'md')
end
   database:del('bot:voice:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> voice ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الصوت"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "voice warn" or UNTSHAKE[2] == "الصوت بالتحذير" then
	  if database:get('bot:voice:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> voice ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الصوت"..lockwarn.." ", 1, 'md')
end
   database:del('bot:voice:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> voice warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الصوت"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "links" or UNTSHAKE[2] == "الروابط" then
	  if database:get('bot:links:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> links has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الروابط"..lockmute.." ", 1, 'md')
end
   database:del('bot:links:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> links is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الروابط"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "links ban" or UNTSHAKE[2] == "الروابط بالطرد" then
	  if database:get('bot:links:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> links ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الروابط"..lockban.." ", 1, 'md')
end
   database:del('bot:links:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> links ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الروابط"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "\n💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "links warn" or UNTSHAKE[2] == "الروابط بالتحذير" then
	  if database:get('bot:links:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> links ban has been_ *unLocked*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الروابط"..lockwarn.." ", 1, 'md')
end
   database:del('bot:links:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> links warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الروابط"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "location" or UNTSHAKE[2] == "الشبكات" then
	  if database:get('bot:location:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> location has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الشبكات"..lockmute.." ", 1, 'md')
end
   database:del('bot:location:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> location is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الشبكات"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "location ban" or UNTSHAKE[2] == "الشبكات بالطرد" then
	  if database:get('bot:location:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> location ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الشبكات"..lockban.." ", 1, 'md')
end
   database:del('bot:location:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> location ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الشبكات"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "location warn" or UNTSHAKE[2] == "الشبكات بالتحذير" then
	  if database:get('bot:location:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> location ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الشبكات"..lockwarn.." ", 1, 'md')
end
   database:del('bot:location:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> location warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الشبكات"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "tag" or UNTSHAKE[2] == "المعرف" then
	  if database:get('bot:tag:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> tag has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح المعرف"..lockmute.." ", 1, 'md')
end
   database:del('bot:tag:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> tag is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح المعرف"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "tag ban" or UNTSHAKE[2] == "المعرف بالطرد" then
	  if database:get('bot:tag:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> tag ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح المعرف"..lockban.." ", 1, 'md')
end
   database:del('bot:tag:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> tag ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح المعرف"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "tag warn" or UNTSHAKE[2] == "المعرف بالتحذير" then
	  if database:get('bot:tag:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> tag ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح المعرف"..lockwarn.." ", 1, 'md')
end
   database:del('bot:tag:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> tag warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح المعرف"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "hashtag" or UNTSHAKE[2] == "التاك" then
	  if database:get('bot:hashtag:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> hashtag has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح التاك"..lockmute.." ", 1, 'md')
end
   database:del('bot:hashtag:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> hashtag is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح التاك"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "hashtag ban" or UNTSHAKE[2] == "التاك بالطرد" then
	  if database:get('bot:hashtag:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> hashtag ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح التاك"..lockban.." ", 1, 'md')
end
   database:del('bot:hashtag:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> hashtag ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح التاك"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "hashtag warn" or UNTSHAKE[2] == "التاك بالتحذير" then
	  if database:get('bot:hashtag:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> hashtag ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح التاك"..lockwarn.." ", 1, 'md')
end
   database:del('bot:hashtag:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> hashtag warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح التاك"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "contact" or UNTSHAKE[2] == "الجهات" then
	  if database:get('bot:contact:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> contact has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الجهات"..lockmute.." ", 1, 'md')
end
   database:del('bot:contact:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> contact is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الجهات"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "contact ban" or UNTSHAKE[2] == "الجهات بالطرد" then
	  if database:get('bot:contact:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> contact ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الجهات"..lockban.." ", 1, 'md')
end
   database:del('bot:contact:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> contact ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الجهات"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "contact warn" or UNTSHAKE[2] == "الجهات بالتحذير" then
	  if database:get('bot:contact:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> contact ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الجهات"..lockwarn.." ", 1, 'md')
end
   database:del('bot:contact:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> contact warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الجهات"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "webpage" or UNTSHAKE[2] == "المواقع" then
	  if database:get('bot:webpage:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> webpage has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح المواقع"..lockmute.." ", 1, 'md')
end
   database:del('bot:webpage:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> webpage is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح المواقع"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "webpage ban" or UNTSHAKE[2] == "المواقع بالطرد" then
	  if database:get('bot:webpage:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> webpage ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح المواقع"..lockban.." ", 1, 'md')
end
   database:del('bot:webpage:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> webpage ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح المواقع"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "webpage warn" or UNTSHAKE[2] == "المواقع بالتحذير" then
	  if database:get('bot:webpage:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> webpage ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح المواقع"..lockwarn.." ", 1, 'md')
end
   database:del('bot:webpage:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> webpage warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح المواقع"..lockwarn.." ", 1, 'md')
end
end
end
end
  getUser(msg.sender_user_id_, keko333)
local keko_info = nil
   function keko333(extra,result,success)
   keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
local lockmute = "\n🗑┇خاصية ~⪼ المسح"
  local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
   local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "arabic" or UNTSHAKE[2] == "العربيه" then
	  if database:get('bot:arabic:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> arabic has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح العربيه"..lockmute.." ", 1, 'md')
end
   database:del('bot:arabic:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> arabic is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح العربيه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "arabic ban" or UNTSHAKE[2] == "العربيه بالطرد" then
	  if database:get('bot:arabic:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> arabic ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح العربيه"..lockban.." ", 1, 'md')
end
   database:del('bot:arabic:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> arabic ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح العربيه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "arabic warn" or UNTSHAKE[2] == "العربيه بالتحذير" then
	  if database:get('bot:arabic:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> arabic ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح العربيه"..lockwarn.." ", 1, 'md')
end
   database:del('bot:arabic:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> arabic warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح العربيه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "english" or UNTSHAKE[2] == "الانكليزيه" then
	  if database:get('bot:english:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> english has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الانكليزيه"..lockmute.." ", 1, 'md')
end
   database:del('bot:english:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> english is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الانكليزيه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "english ban" or UNTSHAKE[2] == "الانكليزيه بالطرد" then
	  if database:get('bot:english:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> english ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الانكليزيه"..lockban.." ", 1, 'md')
end
   database:del('bot:english:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> english ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الانكليزيه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "english warn" or UNTSHAKE[2] == "الانكليزيه بالتحذير" then
	  if database:get('bot:english:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> english ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الانكليزيه"..lockwarn.." ", 1, 'md')
end
   database:del('bot:english:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> english warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الانكليزيه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "spam del" or UNTSHAKE[2] == "الكلايش" then
	  if database:get('bot:spam:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> spam has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الكلايش"..lockmute.." ", 1, 'md')
end
   database:del('bot:spam:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> spam is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الكلايش"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "spam warn" or UNTSHAKE[2] == "الكلايش بالتحذير" then
	  if database:get('bot:spam:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> spam ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الكلايش"..lockwarn.." ", 1, 'md')
end
   database:del('bot:spam:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> spam warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الكلايش"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "sticker" or UNTSHAKE[2] == "الملصقات" then
	  if database:get('bot:sticker:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> sticker has been_ *unLocked*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الملصقات"..lockmute.." ", 1, 'md')
end
   database:del('bot:sticker:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> sticker is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الملصقات"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "sticker ban" or UNTSHAKE[2] == "الملصقات بالطرد" then
	  if database:get('bot:sticker:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> sticker ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الملصقات"..lockban.." ", 1, 'md')
end
   database:del('bot:sticker:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> sticker ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الملصقات"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "sticker warn" or UNTSHAKE[2] == "الملصقات بالتحذير" then
	  if database:get('bot:sticker:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> sticker ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الملصقات"..lockwarn.." ", 1, 'md')
end
   database:del('bot:sticker:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> sticker warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الملصقات"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
function keko333(extra,result,success)
   keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "file" or UNTSHAKE[2] == "الملفات" then
	  if database:get('bot:document:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> file has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الملفات"..lockmute.." ", 1, 'md')
end
   database:del('bot:document:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> file is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الملفات"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "file ban" or UNTSHAKE[2] == "الملفات بالطرد" then
	  if database:get('bot:document:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> file ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الملفات"..lockban.." ", 1, 'md')
end
   database:del('bot:document:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> file ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الملفات"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "file warn" or UNTSHAKE[2] == "الملفات بالتحذير" then
	  if database:get('bot:document:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> file ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الملفات"..lockwarn.." ", 1, 'md')
end
   database:del('bot:document:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> file warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الملفات"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"

if unmutept[2] == "markdown" or UNTSHAKE[2] == "الماركدون" then
	  if database:get('bot:markdown:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> markdown has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الماركدون"..lockmute.." ", 1, 'md')
end
   database:del('bot:markdown:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> markdown is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الماركدون"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "markdown ban" or UNTSHAKE[2] == "الماركدون بالطرد" then
	  if database:get('bot:markdown:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> markdown ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الماركدون"..lockban.." ", 1, 'md')
end
   database:del('bot:markdown:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> markdown ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الماركدون"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "\n💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "markdown warn" or UNTSHAKE[2] == "الماركدون بالتحذير" then
	  if database:get('bot:markdown:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> markdown ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الماركدون"..lockwarn.." ", 1, 'md')
end
   database:del('bot:markdown:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> markdown warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الماركدون"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
function keko333(extra,result,success)
   keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"

	  if unmutept[2] == "service" or UNTSHAKE[2] == "الاشعارات" then
	  if database:get('bot:tgservice:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> tgservice has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الاشعارات"..lockmute.." ", 1, 'md')
end
   database:del('bot:tgservice:mute'..msg.chat_id_)
 else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> tgservice is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الاشعارات"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "fwd" or UNTSHAKE[2] == "التوجيه" then
	  if database:get('bot:forward:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> forward has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح التوجيه"..lockmute.." ", 1, 'md')
end
   database:del('bot:forward:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> forward is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح التوجيه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "fwd ban" or UNTSHAKE[2] == "التوجيه بالطرد" then
	  if database:get('bot:forward:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> forward ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح التوجيه"..lockban.." ", 1, 'md')
end
   database:del('bot:forward:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> forward ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح التوجيه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "fwd warn" or UNTSHAKE[2] == "التوجيه بالتحذير" then
	  if database:get('bot:forward:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> forward ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح التوجيه"..lockwarn.." ", 1, 'md')
end
   database:del('bot:forward:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> forward warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح التوجيه"..lockwarn.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "\n💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "cmd" or UNTSHAKE[2] == "الشارحه" then
	  if database:get('bot:cmd:mute'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> cmd has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الشارحه"..lockmute.." ", 1, 'md')
end
   database:del('bot:cmd:mute'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> cmd is already_ *unLocked*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الشارحه"..lockmute.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "cmd ban" or UNTSHAKE[2] == "الشارحه بالطرد" then
	  if database:get('bot:cmd:ban'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> cmd ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الشارحه"..lockban.." ", 1, 'md')
end
   database:del('bot:cmd:ban'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> cmd ban is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الشارحه"..lockban.." ", 1, 'md')
end
end
end
end
getUser(msg.sender_user_id_, keko333)
 local keko_info = nil
 function keko333(extra,result,success)
keko_info ='['..result.first_name_..'](t.me/'..(result.username_ or 'لا يوجد معرف')..')'
  local lockmute = "\n🗑┇خاصية ~⪼ المسح"
local lockwarn = "\n📛┇خاصية ~⪼ التحذير"
local lockban = "\n🚫┇خاصية ~⪼ الطرد"
local infoo = "💬┇بواسطه ~⪼ [(] "..keko_info.." [)]\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
if unmutept[2] == "cmd warn" or UNTSHAKE[2] == "الشارحه بالتحذير" then
	  if database:get('bot:cmd:warn'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_> cmd ban has been_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇تم فتح الشارحه"..lockwarn.." ", 1, 'md')
end
   database:del('bot:cmd:warn'..msg.chat_id_)
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> cmd warn is already_ *unLocked*', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, ""..infoo.."☑┇بالفعل تم فتح الشارحه"..lockwarn.." ", 1, 'md')
end
end
end
	end
	end
  getUser(msg.sender_user_id_, keko333)
	-----------------------------------------------------------------------------------------------
if text:match("^[Cc][Ll][Ee][Aa][Nn] [Gg][Bb][Aa][Nn][Ll][Ii][Ss][Tt]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or text:match("^مسح قائمه العام$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:lang:'..msg.chat_id_) then
text = '_> Banall has been_ *Cleaned*'
else
text = '☑┇تم مسح قائمه العام️'
end
database:del('bot:gbanned:')
	send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
  end

if text:match("^[Cc][Ll][Ee][Aa][Nn] [Gg][Ss][Ii][Ll][Ee][Nn][Tt][Ll][Ii][Ss][Tt$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or text:match("^مسح المكتومين عام") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:lang:'..msg.chat_id_) then
text = '_> Banall has been_ *Cleaned*'
else
text = '☑┇ تم مسح المكتومين عام️'
end
database:del('bot:gmuted:')
	send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
  end

	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('مسح','clean')
  	if text:match("^[Cc][Ll][Ee][Aa][Nn] (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local txt = {string.match(text, "^([Cc][Ll][Ee][Aa][Nn]) (.*)$")}
 if txt[2] == 'banlist' or txt[2] == 'Banlist' or txt[2] == 'المحظورين' then
	database:del('bot:banned:'..msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Banlist has been_ *Cleaned*', 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '☑️┇تم مسح المحظورين  من البوت ️', 1, 'md')
end
end

 if txt[2] == 'creators' and is_sudo(msg) or txt[2] == 'creatorlist' and is_sudo(msg) or txt[2] == 'Creatorlist' and is_sudo(msg) or txt[2] == 'Creators' and is_sudo(msg) or txt[2] == 'المنشئين' and is_sudo(msg) then
	database:del('bot:creator:'..msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Creator has been_ *Cleaned*', 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '☑┇تم مسح قائمه المنشئين', 1, 'md')
end
 end
if txt[2] == 'bots' or txt[2] == 'Bots' or txt[2] == 'البوتات' then
local function cb(extra,result,success)
local bots = result.members_
for i=0 , #bots do
  if tonumber(bots[i].user_id_) ~= tonumber(bot_id) then chat_kick(msg.chat_id_,bots[i].user_id_)
end
end
end
bot.channel_get_bots(msg.chat_id_,cb)
if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_> All bots_ *kicked!*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم مسح جميع البوتات', 1, 'md')
end
	end
	   if txt[2] == 'modlist' and is_owner(msg.sender_user_id_, msg.chat_id_) or txt[2] == 'Modlist' and is_owner(msg.sender_user_id_, msg.chat_id_) or txt[2] == 'الادمنيه' and is_owner(msg.sender_user_id_, msg.chat_id_) then
	database:del('bot:mods:'..msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Modlist has been_ *Cleaned*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم مسح قائمه الادمنيه', 1, 'md')
end
end
	   if txt[2] == 'viplist' and is_owner(msg.sender_user_id_, msg.chat_id_) or txt[2] == 'Viplist' and is_owner(msg.sender_user_id_, msg.chat_id_) or txt[2] == 'الاعضاء المميزين' and is_owner(msg.sender_user_id_, msg.chat_id_) then
	database:del('bot:vipgp:'..msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Viplist has been_ *Cleaned*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم مسح قائمه الاعضاء المميزين', 1, 'md')
end
 end
	   if txt[2] == 'owners' and is_creator(msg.sender_user_id_, msg.chat_id_) or txt[2] == 'Owners' and is_creator(msg.sender_user_id_, msg.chat_id_) or txt[2] == 'المدراء' and is_creator(msg.sender_user_id_, msg.chat_id_) then
	database:del('bot:owners:'..msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> ownerlist has been_ *Cleaned*', 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '☑┇تم مسح قائمه المدراء', 1, 'md')
end
 end
	   if txt[2] == 'rules' or txt[2] == 'Rules' or txt[2] == 'القوانين' then
	database:del('bot:rules'..msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> rules has been_ *Cleaned*', 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '☑┇تم مسح القوانين المحفوظه', 1, 'md')
end
 end
	   if txt[2] == 'link' or  txt[2] == 'Link' or  txt[2] == 'الرابط' then
	database:del('bot:group:link'..msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> link has been_ *Cleaned*', 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '☑┇تم مسح الرابط المحفوظ', 1, 'md')
end
 end
	   if txt[2] == 'badlist' or txt[2] == 'Badlist' or txt[2] == 'قائمه المنع' then
	database:del('bot:filters:'..msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> badlist has been_ *Cleaned*', 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '☑┇تم مسح قائمه المنع', 1, 'md')
end
 end
	   if txt[2] == 'silentlist' or txt[2] == 'Silentlist' or txt[2] == 'المكتومين' then
	database:del('bot:muted:'..msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> silentlist has been_ *Cleaned*', 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '☑┇تم مسح قائمه المكتومين', 1, 'md')
end
 end

end

local text = msg.content_.text_:gsub('تنظيف قائمه المحظورين','clean blocklist')
  	if text:match("^[Cc][Ll][Ee][Aa][Nn] [Bb][Ll][Oo][Cc][Kk][Ll][Ii][Ss][Tt]$") and is_creator(msg.sender_user_id_, msg.chat_id_) then
	local txt = {string.match(text, "^([Cc][Ll][Ee][Aa][Nn] [Bb][Ll][Oo][Cc][Kk][Ll][Ii][Ss][Tt])$")}
  local function cb(extra,result,success)
  local list = result.members_
for i=0 , #list do
bot.changeChatMemberStatus(msg.chat_id_, list[i].user_id_, "Left")
end
if database:get('bot:lang:'..msg.chat_id_) then
text = '_> blocklist has been_ *Cleaned*'
else
text = '☑️┇تم تنظيف قائمه المحظورين في المجموعه ️'
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
 bot.channel_get_kicked(msg.chat_id_,cb)
end

local text = msg.content_.text_:gsub('اضافه قائمه المحظورين','add blocklist')
  	if text:match("^[Aa][Dd][Dd] [Bb][Ll][Oo][Cc][Kk][Ll][Ii][Ss][Tt]$") and is_creator(msg.sender_user_id_, msg.chat_id_) then
	local txt = {string.match(text, "^([Aa][Dd][Dd] [Bb][Ll][Oo][Cc][Kk][Ll][Ii][Ss][Tt])$")}
  local function cb(extra,result,success)
  local list = result.members_
for k,v in pairs(list) do
bot.addChatMember(msg.chat_id_, v.user_id_, 200, dl_cb, nil)
end
if database:get('bot:lang:'..msg.chat_id_) then
text = '_> blocklist has been_ *Added*'
else
text = '☑┇تم اضافه قائمه المحظورين للمجموعه️'
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
 bot.channel_get_kicked(msg.chat_id_,cb)
end

local text = msg.content_.text_:gsub('طرد المحذوفين','clean delete')
  	if text:match("^[Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Ll][Ee][Tt][Ee]$") and is_creator(msg.sender_user_id_, msg.chat_id_) then
	local txt = {string.match(text, "^([Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Ll][Ee][Tt][Ee])$")}
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)
  if chat_id:match('^-100') then
local channel_id = chat_id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
  else
local group_id = chat_id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
  end
  return chat
end
  local function check_delete(arg, data)
for k, v in pairs(data.members_) do
local function clean_cb(arg, data)
if not data.first_name_ then
bot.changeChatMemberStatus(msg.chat_id_, data.id_, "Kicked")
end
end
bot.getUser(v.user_id_, clean_cb)
end
if database:get('bot:lang:'..msg.chat_id_) then
text = '_> delete accounts has been_ *Cleaned*'
else
text = '☑┇تم طرد الحسابات المحذوفه'
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
 end
  tdcli_function ({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID,offset_ = 0,limit_ = 5000}, check_delete, nil)
  end

local text = msg.content_.text_:gsub('طرد المتروكين','clean deactive')
  	if text:match("^[Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Aa][Cc][Tt][Ii][Vv][Ee]$") and is_creator(msg.sender_user_id_, msg.chat_id_) then
	local txt = {string.match(text, "^([Cc][Ll][Ee][Aa][Nn] [Dd][Ee][Aa][Cc][Tt][Ii][Vv][Ee])$")}
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)
  if chat_id:match('^-100') then
local channel_id = chat_id:gsub('-100', '')
chat = {ID = channel_id, type = 'channel'}
  else
local group_id = chat_id:gsub('-', '')
chat = {ID = group_id, type = 'group'}
  end
  return chat
end
  local function check_deactive(arg, data)
for k, v in pairs(data.members_) do
local function clean_cb(arg, data)
if data.type_.ID == "UserTypeGeneral" then
if data.status_.ID == "UserStatusEmpty" then
bot.changeChatMemberStatus(msg.chat_id_, data.id_, "Kicked")
end
end
end
bot.getUser(v.user_id_, clean_cb)
end
if database:get('bot:lang:'..msg.chat_id_) then
text = '_> delete accounts has been_ *Cleaned*'
else
text = '☑️┇تم طرد الحسابات المتروكة من المجموعة'
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
 end
  tdcli_function ({ID = "GetChannelMembers",channel_id_ = getChatId(msg.chat_id_).ID,offset_ = 0,limit_ = 5000}, check_deactive, nil)
  end

if text:match("^[Uu][Pp][Dd][Aa][Tt][Ee] [Ss][Oo][Uu][Rr][Cc][Ee]$") or text:match("^تحديث السورس$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '*Updated*', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '☑┇تم التحديث', 1, 'md')
   end
os.execute('rm -rf TSHAKE.lua')
os.execute('wget https://raw.githubusercontent.com/moodlIMyIl/TshAkEapi/master/TSHAKE.lua')
 os.execute('./TSHAKE-Auto.sh')
 return false end

 local text = msg.content_.text_:gsub('ادمنيه المجموعه','admin group')
if text:match("^[Aa][Dd][Mm][Ii][Nn] [Gg][Rr][Oo][Uu][Pp]$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
   local txt = {string.match(text, "^[Aa][Dd][Mm][Ii][Nn] [Gg][Rr][Oo][Uu][Pp]$")}
   local function cb(extra,result,success)
   local list = result.members_
if database:get('bot:lang:'..msg.chat_id_) then
  text = '<b>List administrators group</b> : \n\n'
  else
  text = '📊┇ادمنيه الكروب\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n'
  end
 local n = 0
   for k,v in pairs(list) do
 n = (n + 1)
   local user_info = database:hgetall('user:'..v.user_id_)
if user_info and user_info.username then
 local username = user_info.username
 text = text.."<b>|"..n.."|</b>~⪼(@"..username..")\n"
else
 text = text.."<b>|"..n.."|</b>~⪼(<code>"..v.user_id_.."</code>)\n"
end
   end
 send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
 end
  bot.channel_get_admins(msg.chat_id_,cb)
 end

local text = msg.content_.text_:gsub('رفع الادمنيه','setmote admins')
  	if text:match("^[Ss][Ee][Tt][Mm][Oo][Tt][Ee] [Aa][Dd][Mm][Ii][Nn][Ss]$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
	local txt = {string.match(text, "^[Ss][Ee][Tt][Mm][Oo][Tt][Ee] [Aa][Dd][Mm][Ii][Nn][Ss]$")}
  local function cb(extra,result,success)
  local list = result.members_
if database:get('bot:lang:'..msg.chat_id_) then
moody = '<b>List administrators group setmote BOT</b> : \n\n'
else
moody = '📊┇ تم رفع ادمنيه المجموعه في البوت\n'
end
local n = 0
for k,v in pairs(list) do
n = (n + 1)
local hash = 'bot:mods:'..msg.chat_id_
database:sadd(hash, v.user_id_)
end
send(msg.chat_id_, msg.id_, 1, moody, 1, 'html')
end
 bot.channel_get_admins(msg.chat_id_,cb)
end
	-----------------------------------------------------------------------------------------------
  	 if text:match("^[Ss] [Dd][Ee][Ll]$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	if database:get('bot:muteall'..msg.chat_id_) then
	mute_all = '`lock | 🔐`'
	else
	mute_all = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:text:mute'..msg.chat_id_) then
	mute_text = '`lock | 🔐`'
	else
	mute_text = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:photo:mute'..msg.chat_id_) then
	mute_photo = '`lock | 🔐`'
	else
	mute_photo = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:video:mute'..msg.chat_id_) then
	mute_video = '`lock | 🔐`'
	else
	mute_video = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:gifs:mute'..msg.chat_id_) then
	mute_gifs = '`lock | 🔐`'
	else
	mute_gifs = '`unlock | 🔓`'
	end
	------------
	if database:get('anti-flood:'..msg.chat_id_) then
	mute_flood = '`unlock | 🔓`'
	else
	mute_flood = '`lock | 🔐`'
	end
	------------
	if not database:get('flood:max:'..msg.chat_id_) then
	flood_m = 10
	else
	flood_m = database:get('flood:max:'..msg.chat_id_)
end
	------------
	if not database:get('flood:time:'..msg.chat_id_) then
	flood_t = 1
	else
	flood_t = database:get('flood:time:'..msg.chat_id_)
	end
	------------
	if database:get('bot:music:mute'..msg.chat_id_) then
	mute_music = '`lock | 🔐`'
	else
	mute_music = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:bots:mute'..msg.chat_id_) then
	mute_bots = '`lock | 🔐`'
	else
	mute_bots = '`unlock | 🔓`'
	end

	if database:get('bot:bots:ban'..msg.chat_id_) then
	mute_botsb = '`lock | 🔐`'
	else
	mute_botsb = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:inline:mute'..msg.chat_id_) then
	mute_in = '`lock | 🔐`'
	else
	mute_in = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:voice:mute'..msg.chat_id_) then
	mute_voice = '`lock | 🔐`'
	else
	mute_voice = '`unlock | 🔓`'
end

	if database:get('bot:document:mute'..msg.chat_id_) then
	mute_doc = '`lock | 🔐`'
	else
	mute_doc = '`unlock | 🔓`'
end

	if database:get('bot:markdown:mute'..msg.chat_id_) then
	mute_mdd = '`lock | 🔐`'
	else
	mute_mdd = '`unlock | 🔓`'
	end
	------------
	if database:get('editmsg'..msg.chat_id_) then
	mute_edit = '`lock | 🔐`'
	else
	mute_edit = '`unlock | 🔓`'
	end
------------
	if database:get('bot:links:mute'..msg.chat_id_) then
	mute_links = '`lock | 🔐`'
	else
	mute_links = '`unlock | 🔓`'
	end
------------
	if database:get('bot:pin:mute'..msg.chat_id_) then
	lock_pin = '`lock | 🔐`'
	else
	lock_pin = '`unlock | 🔓`'
	end
------------
	if database:get('bot:sticker:mute'..msg.chat_id_) then
	lock_sticker = '`lock | 🔐`'
	else
	lock_sticker = '`unlock | 🔓`'
	end
	------------
if database:get('bot:tgservice:mute'..msg.chat_id_) then
	lock_tgservice = '`lock | 🔐`'
	else
	lock_tgservice = '`unlock | 🔓`'
	end
	------------
if database:get('bot:webpage:mute'..msg.chat_id_) then
	lock_wp = '`lock | 🔐`'
	else
	lock_wp = '`unlock | 🔓`'
	end
	------------
if database:get('bot:hashtag:mute'..msg.chat_id_) then
	lock_htag = '`lock | 🔐`'
	else
	lock_htag = '`unlock | 🔓`'
end

   if database:get('bot:cmd:mute'..msg.chat_id_) then
	lock_cmd = '`lock | 🔐`'
	else
	lock_cmd = '`unlock | 🔓`'
	end
	------------
if database:get('bot:tag:mute'..msg.chat_id_) then
	lock_tag = '`lock | 🔐`'
	else
	lock_tag = '`unlock | 🔓`'
	end
	------------
if database:get('bot:location:mute'..msg.chat_id_) then
	lock_location = '`lock | 🔐`'
	else
	lock_location = '`unlock | 🔓`'
end
  ------------
if not database:get('bot:sens:spam'..msg.chat_id_) then
spam_c = 300
else
spam_c = database:get('bot:sens:spam'..msg.chat_id_)
end

if not database:get('bot:sens:spam:warn'..msg.chat_id_) then
spam_d = 300
else
spam_d = database:get('bot:sens:spam:warn'..msg.chat_id_)
end

	------------
  if database:get('bot:contact:mute'..msg.chat_id_) then
	lock_contact = '`lock | 🔐`'
	else
	lock_contact = '`unlock | 🔓`'
	end
	------------
  if database:get('bot:spam:mute'..msg.chat_id_) then
	mute_spam = '`lock | 🔐`'
	else
	mute_spam = '`unlock | 🔓`'
end

	if database:get('anti-flood:warn'..msg.chat_id_) then
	lock_flood = '`unlock | 🔓`'
	else
	lock_flood = '`lock | 🔐`'
end

	if database:get('anti-flood:del'..msg.chat_id_) then
	del_flood = '`unlock | 🔓`'
	else
	del_flood = '`lock | 🔐`'
	end
	------------
if database:get('bot:english:mute'..msg.chat_id_) then
	lock_english = '`lock | 🔐`'
	else
	lock_english = '`unlock | 🔓`'
	end
	------------
if database:get('bot:arabic:mute'..msg.chat_id_) then
	lock_arabic = '`lock | 🔐`'
	else
	lock_arabic = '`unlock | 🔓`'
	end
	------------
if database:get('bot:forward:mute'..msg.chat_id_) then
	lock_forward = '`lock | 🔐`'
	else
	lock_forward = '`unlock | 🔓`'
end

if database:get('bot:rep:mute'..msg.chat_id_) then
	lock_rep = '`lock | 🔐`'
	else
	lock_rep = '`unlock | 🔓`'
	end

if database:get('bot:note:mute'..msg.chat_id_) then
	lock_note = '`lock | 🔐`'
	else
	lock_note = '`unlock | 🔓`'
	end
	------------
	if database:get("bot:welcome"..msg.chat_id_) then
	send_welcome = '`active | ✔`'
	else
	send_welcome = '`inactive | ⭕`'
end
		if not database:get('flood:max:warn'..msg.chat_id_) then
	flood_warn = 10
	else
	flood_warn = database:get('flood:max:warn'..msg.chat_id_)
end
		if not database:get('flood:max:del'..msg.chat_id_) then
	flood_del = 10
	else
	flood_del = database:get('flood:max:del'..msg.chat_id_)
end
	------------
	local ex = database:ttl("bot:charge:"..msg.chat_id_)
if ex == -1 then
exp_dat = '`NO Fanil`'
else
exp_dat = math.floor(ex / 86400) + 1
			end
 	------------
	 local TXT = "*Group Settings Del*\n======================\n*Del all* : "..mute_all.."\n" .."*Del Links* : "..mute_links.."\n" .."*Del Edit* : "..mute_edit.."\n" .."*Del Bots* : "..mute_bots.."\n" .."*Ban Bots* : "..mute_botsb.."\n" .."*Del Inline* : "..mute_in.."\n" .."*Del English* : "..lock_english.."\n" .."*Del Forward* : "..lock_forward.."\n" .."*Del Pin* : "..lock_pin.."\n" .."*Del Arabic* : "..lock_arabic.."\n" .."*Del Hashtag* : "..lock_htag.."\n".."*Del tag* : "..lock_tag.."\n" .."*Del Webpage* : "..lock_wp.."\n" .."*Del Location* : "..lock_location.."\n" .."*Del Tgservice* : "..lock_tgservice.."\n"
.."*Del Spam* : "..mute_spam.."\n" .."*Del Photo* : "..mute_photo.."\n" .."*Del video note* : "..lock_note.."\n" .."*Del Text* : "..mute_text.."\n" .."*Del Gifs* : "..mute_gifs.."\n" .."*Del Voice* : "..mute_voice.."\n" .."*Del Music* : "..mute_music.."\n" .."*Del Video* : "..mute_video.."\n*Del Cmd* : "..lock_cmd.."\n" .."*Del Markdown* : "..mute_mdd.."\n*Del Document* : "..mute_doc.."\n" .."*Flood Ban* : "..mute_flood.."\n" .."*Flood Mute* : "..lock_flood.."\n" .."*Flood del* : "..del_flood.."\n" .."*Setting reply* : "..lock_rep.."\n"
.."======================\n*Welcome* : "..send_welcome.."\n*Flood Time*  "..flood_t.."\n" .."*Flood Max* : "..flood_m.."\n" .."*Flood Mute* : "..flood_warn.."\n" .."*Flood del* : "..flood_del.."\n" .."*Number Spam* : "..spam_c.."\n" .."*Warn Spam* : "..spam_d.."\n"
 .."*Expire* : "..exp_dat.."\n======================"
   send(msg.chat_id_, msg.id_, 1, TXT, 1, 'md')
end

local text = msg.content_.text_:gsub('اعدادات المسح','sdd1')
  	 if text:match("^[Ss][Dd][Dd]1$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	if database:get('bot:muteall'..msg.chat_id_) then
----------------------------------------------------
   	mute_all = '✔️┇'
   	else
   	mute_all = '✖️┇'
   	end
   	------------
   	if database:get('bot:text:mute'..msg.chat_id_) then
   	mute_text = '✔️┇'
   	else
   	mute_text = '✖️┇'
   	end
   	------------
   	if database:get('bot:photo:mute'..msg.chat_id_) then
   	mute_photo = '✔️┇'
   	else
   	mute_photo = '✖️┇'
   	end
   	------------
   	if database:get('bot:video:mute'..msg.chat_id_) then
   	mute_video = '✔️┇'
   	else
   	mute_video = '✖️┇'
   	end
   	if database:get('bot:note:mute'..msg.chat_id_) then
   	mute_note = '✔️┇'
   	else
   	mute_note = '✖️┇'
   	end
   	------------
   	if database:get('bot:gifs:mute'..msg.chat_id_) then
   	mute_gifs = '✔️┇'
   	else
   	mute_gifs = '✖️┇'
   	end
   	------------
   	if database:get('anti-flood:'..msg.chat_id_) then
   	mute_flood = '✔️┇'
   	else
   	mute_flood = '✖️┇'
   end
   	------------
   	if not database:get('flood:max:'..msg.chat_id_) then
   	flood_m = 10
   	else
   	flood_m = database:get('flood:max:'..msg.chat_id_)
   end
   	------------
   	if not database:get('flood:time:'..msg.chat_id_) then
   	flood_t = 1
   	else
   	flood_t = database:get('flood:time:'..msg.chat_id_)
   	end
   	------------
   	if database:get('bot:music:mute'..msg.chat_id_) then
   	mute_music = '✔️┇'
   	else
   	mute_music = '✖️┇'
   	end
   	------------
   	if database:get('bot:bots:mute'..msg.chat_id_) then
   	mute_bots = '✔️┇'
   	else
   	mute_bots = '✖️┇'
   	end

   	if database:get('bot:bots:ban'..msg.chat_id_) then
   	mute_botsb = '✔️┇'
   	else
   	mute_botsb = '✖️┇'
   	end
   	------------
   	if database:get('bot:inline:mute'..msg.chat_id_) then
   	mute_in = '✔️┇'
   	else
   	mute_in = '✖️┇'
   	end
   	------------
   	if database:get('bot:voice:mute'..msg.chat_id_) then
   	mute_voice = '✔️┇'
   	else
   	mute_voice = '✖️┇'
   	end
   	------------
   	if database:get('editmsg'..msg.chat_id_) then
   	mute_edit = '✔️┇'
   	else
   	mute_edit = '✖️┇'
   	end
 ------------
   	if database:get('bot:links:mute'..msg.chat_id_) then
   	mute_links = '✔️┇'
   	else
   	mute_links = '✖️┇'
   	end
 ------------
   	if database:get('bot:pin:mute'..msg.chat_id_) then
   	lock_pin = '✔️┇'
   	else
   	lock_pin = '✖️┇'
   end

   	if database:get('bot:document:mute'..msg.chat_id_) then
   	mute_doc = '✔️┇'
   	else
   	mute_doc = '✖️┇'
   end

   	if database:get('bot:markdown:mute'..msg.chat_id_) then
   	mute_mdd = '✔️┇'
   	else
   	mute_mdd = '✖️┇'
   	end
 ------------
   	if database:get('bot:sticker:mute'..msg.chat_id_) then
   	lock_sticker = '✔️┇'
   	else
   	lock_sticker = '✖️┇'
   	end
   	------------
 if database:get('bot:tgservice:mute'..msg.chat_id_) then
   	lock_tgservice = '✔️┇'
   	else
   	lock_tgservice = '✖️┇'
   	end
   	------------
 if database:get('bot:webpage:mute'..msg.chat_id_) then
   	lock_wp = '✔️┇'
   	else
   	lock_wp = '✖️┇'
   	end
   	------------
 if database:get('bot:hashtag:mute'..msg.chat_id_) then
   	lock_htag = '✔️┇'
   	else
   	lock_htag = '✖️┇'
   end

if database:get('bot:cmd:mute'..msg.chat_id_) then
   	lock_cmd = '✔️┇'
   	else
   	lock_cmd = '✖️┇'
   	end
   	------------
 if database:get('bot:tag:mute'..msg.chat_id_) then
   	lock_tag = '✔️┇'
   	else
   	lock_tag = '✖️┇'
   	end
   	------------
 if database:get('bot:location:mute'..msg.chat_id_) then
   	lock_location = '✔️┇'
   	else
   	lock_location = '✖️┇'
   end
------------
   if not database:get('bot:sens:spam'..msg.chat_id_) then
   spam_c = 300
   else
   spam_c = database:get('bot:sens:spam'..msg.chat_id_)
   end

   if not database:get('bot:sens:spam:warn'..msg.chat_id_) then
   spam_d = 300
   else
   spam_d = database:get('bot:sens:spam:warn'..msg.chat_id_)
   end
   	------------
if database:get('bot:contact:mute'..msg.chat_id_) then
   	lock_contact = '✔️┇'
   	else
   	lock_contact = '✖️┇'
   	end
   	------------
if database:get('bot:spam:mute'..msg.chat_id_) then
   	mute_spam = '✔️┇'
   	else
   	mute_spam = '✖️┇'
   	end
   	------------
 if database:get('bot:english:mute'..msg.chat_id_) then
   	lock_english = '✔️┇'
   	else
   	lock_english = '✖️┇'
   	end
   	------------
 if database:get('bot:arabic:mute'..msg.chat_id_) then
   	lock_arabic = '✔️┇'
   	else
   	lock_arabic = '✖️┇'
   end

   	if database:get('anti-flood:warn'..msg.chat_id_) then
   	lock_flood = '✔️┇'
   	else
   	lock_flood = '✖️┇'
   end

   	if database:get('anti-flood:del'..msg.chat_id_) then
   	del_flood = '✔️┇'
   	else
   	del_flood = '✖️┇'
   	end
   	------------
 if database:get('bot:forward:mute'..msg.chat_id_) then
   	lock_forward = '✔️┇'
   	else
   	lock_forward = '✖️┇'
   end

 if database:get('bot:rep:mute'..msg.chat_id_) then
   	lock_rep = '✔️┇'
   	else
   	lock_rep = '✖️┇'
   	end

 if database:get('bot:repsudo:mute'..msg.chat_id_) then
   	lock_repsudo = '✔️┇'
   	else
   	lock_repsudo = '✖️┇'
   	end

 if database:get('bot:repowner:mute'..msg.chat_id_) then
   	lock_repowner = '✔️┇'
   	else
   	lock_repowner = '✖️┇'
   	end

 if database:get('bot:id:mute'..msg.chat_id_) then
   	lock_id = '✔️┇'
   	else
   	lock_id = '✖️┇'
   	end
   	------------
   	if database:get("bot:welcome"..msg.chat_id_) then
   	send_welcome = '✔️┇'
   	else
   	send_welcome = '✖️┇'
   end
		if not database:get('flood:max:warn'..msg.chat_id_) then
	flood_warn = 10
	else
	flood_warn = database:get('flood:max:warn'..msg.chat_id_)
end
	if not database:get('flood:max:del'..msg.chat_id_) then
	flood_del = 10
	else
	flood_del = database:get('flood:max:del'..msg.chat_id_)
end
	------------
	local ex = database:ttl("bot:charge:"..msg.chat_id_)
if ex == -1 then
exp_dat = 'لا نهائي'
else
exp_dat = math.floor(ex / 86400) + 1
			end
 	------------
	 local TXT = "🗑┇اعدادات المجموعه بالمسح\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n✔️┇~⪼ مفعل\n✖️┇~⪼ معطل\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
..mute_all.."كل الوسائط".."\n"
..mute_links.." الروابط".."\n"
..mute_edit .." التعديل".."\n"
..mute_bots .." البوتات".."\n"
..mute_botsb.." البوتات بالطرد".."\n"
..lock_english.." اللغه الانكليزيه".."\n"
..lock_forward.." اعاده التوجيه".."\n"
..lock_wp.." المواقع".."\n\n"
..lock_pin.." التثبيت".."\n"
..lock_arabic.." اللغه العربيه".."\n"
..lock_htag.." التاكات".."\n"
..lock_tag.." المعرفات".."\n"
..lock_location.." الشبكات".."\n"
..lock_tgservice.." الاشعارات".."\n"
..mute_spam.." الكلايش".."\n"
..mute_flood.." التكرار بالطرد".."\n\n"
..lock_flood.." التكرار بالكتم".."\n"
..del_flood.." التكرار بالمسح".."\n"
..mute_text.." الدردشه".."\n"
..mute_gifs.." الصور المتحركه".."\n"
..mute_voice.." الصوتيات".."\n"
..mute_music.." الاغاني".."\n"
..mute_in.." الانلاين".."\n"
..lock_sticker.." الملصقات".."\n\n"
..lock_contact.." جهات الاتصال".."\n"
..mute_video.." الفيديوهات".."\n"
..lock_cmd.." الشارحه".."\n"
..mute_mdd.." الماركدون".."\n"
..mute_doc.." الملفات".."\n"
..mute_photo.." الصور".."\n"
..mute_note.." بصمه الفيديو".."\n"
..lock_rep.." ردود البوت".."\n"
..lock_repsudo.." ردود المطور".."\n\n"
..lock_repowner.." ردود المدير".."\n"
..lock_id.."الايدي".."\n"
..send_welcome.." الترحيب".."\n"
.."┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ️ \n"
..flood_t.." زمن التكرار".."\n"
..flood_m.." عدد التكرار بالطرد".."\n"
..flood_warn.." عدد التكرار بالكتم".."\n"
..flood_del.." عدد التكرار بالمسح".."\n"
..spam_c.." عدد الكلايش بالمسح".."\n"
..spam_d.." عدد الكلايش بالتحذير".."\n"
..exp_dat.." انقضاء البوت".." يوم\n"
.."┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
 send(msg.chat_id_, msg.id_, 1, TXT, 1, 'md')
  end

  	 if text:match("^[Ss] [Ww][Aa][Rr][Nn]$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	if database:get('bot:muteallwarn'..msg.chat_id_) then
	mute_all = '`lock | 🔐`'
	else
	mute_all = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:text:warn'..msg.chat_id_) then
	mute_text = '`lock | 🔐`'
	else
	mute_text = '`unlock | 🔓`'
	end
	if database:get('bot:note:warn'..msg.chat_id_) then
	mute_note = '`lock | 🔐`'
	else
	mute_note = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:photo:warn'..msg.chat_id_) then
	mute_photo = '`lock | 🔐`'
	else
	mute_photo = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:video:warn'..msg.chat_id_) then
	mute_video = '`lock | 🔐`'
	else
	mute_video = '`unlock | 🔓`'
end

	if database:get('bot:spam:warn'..msg.chat_id_) then
	mute_spam = '`lock | 🔐`'
	else
	mute_spam = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:gifs:warn'..msg.chat_id_) then
	mute_gifs = '`lock | 🔐`'
	else
	mute_gifs = '`unlock | 🔓`'
end

	------------
	if database:get('bot:music:warn'..msg.chat_id_) then
	mute_music = '`lock | 🔐`'
	else
	mute_music = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:inline:warn'..msg.chat_id_) then
	mute_in = '`lock | 🔐`'
	else
	mute_in = '`unlock | 🔓`'
	end
	------------
	if database:get('bot:voice:warn'..msg.chat_id_) then
	mute_voice = '`lock | 🔐`'
	else
	mute_voice = '`unlock | 🔓`'
	end
------------
	if database:get('bot:links:warn'..msg.chat_id_) then
	mute_links = '`lock | 🔐`'
	else
	mute_links = '`unlock | 🔓`'
	end
------------
	if database:get('bot:sticker:warn'..msg.chat_id_) then
	lock_sticker = '`lock | 🔐`'
	else
	lock_sticker = '`unlock | 🔓`'
	end
	------------
   if database:get('bot:cmd:warn'..msg.chat_id_) then
	lock_cmd = '`lock | 🔐`'
	else
	lock_cmd = '`unlock | 🔓`'
end

if database:get('bot:webpage:warn'..msg.chat_id_) then
	lock_wp = '`lock | 🔐`'
	else
	lock_wp = '`unlock | 🔓`'
end

	if database:get('bot:document:warn'..msg.chat_id_) then
	mute_doc = '`lock | 🔐`'
	else
	mute_doc = '`unlock | 🔓`'
end

	if database:get('bot:markdown:warn'..msg.chat_id_) then
	mute_mdd = '`lock | 🔐`'
	else
	mute_mdd = '`unlock | 🔓`'
	end
	------------
if database:get('bot:hashtag:warn'..msg.chat_id_) then
	lock_htag = '`lock | 🔐`'
	else
	lock_htag = '`unlock | 🔓`'
end
	if database:get('bot:pin:warn'..msg.chat_id_) then
	lock_pin = '`lock | 🔐`'
	else
	lock_pin = '`unlock | 🔓`'
	end
	------------
if database:get('bot:tag:warn'..msg.chat_id_) then
	lock_tag = '`lock | 🔐`'
	else
	lock_tag = '`unlock | 🔓`'
	end
	------------
if database:get('bot:location:warn'..msg.chat_id_) then
	lock_location = '`lock | 🔐`'
	else
	lock_location = '`unlock | 🔓`'
	end
	------------
if database:get('bot:contact:warn'..msg.chat_id_) then
	lock_contact = '`lock | 🔐`'
	else
	lock_contact = '`unlock | 🔓`'
	end
	------------

if database:get('bot:english:warn'..msg.chat_id_) then
	lock_english = '`lock | 🔐`'
	else
	lock_english = '`unlock | 🔓`'
	end
	------------
if database:get('bot:arabic:warn'..msg.chat_id_) then
	lock_arabic = '`lock | 🔐`'
	else
	lock_arabic = '`unlock | 🔓`'
	end
	------------
if database:get('bot:forward:warn'..msg.chat_id_) then
	lock_forward = '`lock | 🔐`'
	else
	lock_forward = '`unlock | 🔓`'
end
	------------
	------------
	local ex = database:ttl("bot:charge:"..msg.chat_id_)
if ex == -1 then
exp_dat = '`NO Fanil`'
else
exp_dat = math.floor(ex / 86400) + 1
			end
 	------------
	 local TXT = "*Group Settings Warn*\n======================\n*Warn all* : "..mute_all.."\n" .."*Warn Links* : "..mute_links.."\n" .."*Warn Inline* : "..mute_in.."\n" .."*Warn Pin* : "..lock_pin.."\n" .."*Warn English* : "..lock_english.."\n" .."*Warn Forward* : "..lock_forward.."\n" .."*Warn Arabic* : "..lock_arabic.."\n" .."*Warn Hashtag* : "..lock_htag.."\n".."*Warn tag* : "..lock_tag.."\n" .."*Warn Webpag* : "..lock_wp.."\n" .."*Warn Location* : "..lock_location.."\n"
.."*Warn Spam* : "..mute_spam.."\n" .."*Warn Photo* : "..mute_photo.."\n" .."*Warn video note* : "..mute_note.."\n" .."*Warn Text* : "..mute_text.."\n" .."*Warn Gifs* : "..mute_gifs.."\n" .."*Warn Voice* : "..mute_voice.."\n" .."*Warn Music* : "..mute_music.."\n" .."*Warn Video* : "..mute_video.."\n*Warn Cmd* : "..lock_cmd.."\n"  .."*Warn Markdown* : "..mute_mdd.."\n*Warn Document* : "..mute_doc.."\n"
.."*Expire* : "..exp_dat.."\n======================"
   send(msg.chat_id_, msg.id_, 1, TXT, 1, 'md')
end


local text = msg.content_.text_:gsub('اعدادات التحذير','sdd2')
  	 if text:match("^[Ss][Dd][Dd]2$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	if database:get('bot:muteallwarn'..msg.chat_id_) then
	-------------------------------------------------------------------
	mute_all = '✔️┇'
  else
  mute_all = '✖️┇'
  end
------------
if database:get('bot:text:warn'..msg.chat_id_) then
mute_text = '✔️┇'
else
mute_text = '✖️┇'
end

if database:get('bot:note:warn'..msg.chat_id_) then
mute_note = '✔️┇'
else
mute_note = '✖️┇'
end
------------
if database:get('bot:photo:warn'..msg.chat_id_) then
mute_photo = '✔️┇'
else
mute_photo = '✖️┇'
end
------------
if database:get('bot:video:warn'..msg.chat_id_) then
mute_video = '✔️┇'
else
mute_video = '✖️┇'
  end

if database:get('bot:spam:warn'..msg.chat_id_) then
mute_spam = '✔️┇'
else
mute_spam = '✖️┇'
end
------------
if database:get('bot:gifs:warn'..msg.chat_id_) then
mute_gifs = '✔️┇'
else
mute_gifs = '✖️┇'
  end
------------
if database:get('bot:music:warn'..msg.chat_id_) then
mute_music = '✔️┇'
else
mute_music = '✖️┇'
end
------------
if database:get('bot:inline:warn'..msg.chat_id_) then
mute_in = '✔️┇'
else
mute_in = '✖️┇'
end
------------
if database:get('bot:voice:warn'..msg.chat_id_) then
mute_voice = '✔️┇'
else
mute_voice = '✖️┇'
end
  ------------
if database:get('bot:links:warn'..msg.chat_id_) then
mute_links = '✔️┇'
else
mute_links = '✖️┇'
end
  ------------
if database:get('bot:sticker:warn'..msg.chat_id_) then
lock_sticker = '✔️┇'
else
lock_sticker = '✖️┇'
end
------------
  if database:get('bot:cmd:warn'..msg.chat_id_) then
lock_cmd = '✔️┇'
else
lock_cmd = '✖️┇'
  end

  if database:get('bot:webpage:warn'..msg.chat_id_) then
lock_wp = '✔️┇'
else
lock_wp = '✖️┇'
end
------------
  if database:get('bot:hashtag:warn'..msg.chat_id_) then
lock_htag = '✔️┇'
else
lock_htag = '✖️┇'
  end
if database:get('bot:pin:warn'..msg.chat_id_) then
lock_pin = '✔️┇'
else
lock_pin = '✖️┇'
end
------------
  if database:get('bot:tag:warn'..msg.chat_id_) then
lock_tag = '✔️┇'
else
lock_tag = '✖️┇'
end
------------
  if database:get('bot:location:warn'..msg.chat_id_) then
lock_location = '✔️┇'
else
lock_location = '✖️┇'
end
------------
  if database:get('bot:contact:warn'..msg.chat_id_) then
lock_contact = '✔️┇'
else
lock_contact = '✖️┇'
end

  if database:get('bot:english:warn'..msg.chat_id_) then
lock_english = '✔️┇'
else
lock_english = '✖️┇'
end
------------
  if database:get('bot:arabic:warn'..msg.chat_id_) then
lock_arabic = '✔️┇'
else
lock_arabic = '✖️┇'
  end

if database:get('bot:document:warn'..msg.chat_id_) then
mute_doc = '✔️┇'
else
mute_doc = '✖️┇'
  end

if database:get('bot:markdown:warn'..msg.chat_id_) then
mute_mdd = '✔️┇'
else
mute_mdd = '✖️┇'
end
------------
  if database:get('bot:forward:warn'..msg.chat_id_) then
lock_forward = '✔️┇'
else
lock_forward = '✖️┇'
  end
	-----------------------------------------------------------------------------------------------------
	local ex = database:ttl("bot:charge:"..msg.chat_id_)
if ex == -1 then
exp_dat = 'لا نهائي'
else
exp_dat = math.floor(ex / 86400) + 1
			end
 	------------
	local TXT = "🗑┇اعدادات المجموعه بالتحذير\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n✔️┇~⪼ مفعل\n✖️┇~⪼ معطل\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
..mute_all.."كل الوسائط".."\n"
..mute_links.." الروابط".."\n"
..mute_in.." الانلاين".."\n"
..lock_pin.." التثبيت".."\n"
..lock_english.." اللغه الانكليزيه".."\n"
..lock_forward.." اعاده التوجيه".."\n\n"
..lock_arabic.." اللغه العربيه".."\n"
..lock_htag.." التاكات".."\n"
..lock_tag.." المعرفات".."\n"
..lock_wp.." المواقع".."\n"
..lock_location.." الشبكات".."\n"
..mute_spam.." الكلايش".."\n\n"
..mute_photo.." الصور".."\n"
..mute_note.." بصمه الفيديو".."\n"
..mute_text.." الدردشه".."\n"
..mute_gifs.." الصور المتحركه".."\n"
..lock_sticker.." الملصقات".."\n"
..lock_contact.." جهات الاتصال".."\n"
..mute_voice.." الصوتيات".."\n\n"
..mute_music.." الاغاني".."\n"
..mute_video.." الفيديوهات".."\n"
..lock_cmd.." الشارحه".."\n"
..mute_mdd.." الماركدون".."\n"
..mute_doc.." الملفات".."\n"
.."┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
..exp_dat.." انقضاء البوت".." يوم\n"
.."┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
  send(msg.chat_id_, msg.id_, 1, TXT, 1, 'md')
   end

  	 if text:match("^[Ss] [Bb][Aa][Nn]$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	if database:get('bot:muteallban'..msg.chat_id_) then

	------------
	------------
	local ex = database:ttl("bot:charge:"..msg.chat_id_)
if ex == -1 then
exp_dat = '`NO Fanil`'mute_all = '`lock | 🔐`'
else
mute_all = '`unlock | 🔓`'
end
------------
if database:get('bot:text:ban'..msg.chat_id_) then
mute_text = '`lock | 🔐`'
else
mute_text = '`unlock | 🔓`'
end

if database:get('bot:note:ban'..msg.chat_id_) then
mute_note = '`lock | 🔐`'
else
mute_note = '`unlock | 🔓`'
end
------------
if database:get('bot:photo:ban'..msg.chat_id_) then
mute_photo = '`lock | 🔐`'
else
mute_photo = '`unlock | 🔓`'
end
------------
if database:get('bot:video:ban'..msg.chat_id_) then
mute_video = '`lock | 🔐`'
else
mute_video = '`unlock | 🔓`'
end

------------
if database:get('bot:gifs:ban'..msg.chat_id_) then
mute_gifs = '`lock | 🔐`'
else
mute_gifs = '`unlock | 🔓`'
end
------------
if database:get('bot:music:ban'..msg.chat_id_) then
mute_music = '`lock | 🔐`'
else
mute_music = '`unlock | 🔓`'
end
------------
if database:get('bot:inline:ban'..msg.chat_id_) then
mute_in = '`lock | 🔐`'
else
mute_in = '`unlock | 🔓`'
end
------------
if database:get('bot:voice:ban'..msg.chat_id_) then
mute_voice = '`lock | 🔐`'
else
mute_voice = '`unlock | 🔓`'
end
------------
if database:get('bot:links:ban'..msg.chat_id_) then
mute_links = '`lock | 🔐`'
else
mute_links = '`unlock | 🔓`'
end
------------
if database:get('bot:sticker:ban'..msg.chat_id_) then
lock_sticker = '`lock | 🔐`'
else
lock_sticker = '`unlock | 🔓`'
end
------------
   if database:get('bot:cmd:ban'..msg.chat_id_) then
lock_cmd = '`lock | 🔐`'
else
lock_cmd = '`unlock | 🔓`'
end

if database:get('bot:webpage:ban'..msg.chat_id_) then
lock_wp = '`lock | 🔐`'
else
lock_wp = '`unlock | 🔓`'
end
------------
if database:get('bot:hashtag:ban'..msg.chat_id_) then
lock_htag = '`lock | 🔐`'
else
lock_htag = '`unlock | 🔓`'
end
------------
if database:get('bot:tag:ban'..msg.chat_id_) then
lock_tag = '`lock | 🔐`'
else
lock_tag = '`unlock | 🔓`'
end
------------
if database:get('bot:location:ban'..msg.chat_id_) then
lock_location = '`lock | 🔐`'
else
lock_location = '`unlock | 🔓`'
end
------------
if database:get('bot:contact:ban'..msg.chat_id_) then
lock_contact = '`lock | 🔐`'
else
lock_contact = '`unlock | 🔓`'
end
------------
if database:get('bot:english:ban'..msg.chat_id_) then
lock_english = '`lock | 🔐`'
else
lock_english = '`unlock | 🔓`'
end
------------
if database:get('bot:arabic:ban'..msg.chat_id_) then
lock_arabic = '`lock | 🔐`'
else
lock_arabic = '`unlock | 🔓`'
end
------------
if database:get('bot:forward:ban'..msg.chat_id_) then
lock_forward = '`lock | 🔐`'
else
lock_forward = '`unlock | 🔓`'
end

if database:get('bot:document:ban'..msg.chat_id_) then
mute_doc = '`lock | 🔐`'
else
mute_doc = '`unlock | 🔓`'
end

if database:get('bot:markdown:ban'..msg.chat_id_) then
mute_mdd = '`lock | 🔐`'
else
mute_mdd = '`unlock | 🔓`'
end
else
exp_dat = math.floor(ex / 86400) + 1
			end
 	------------
	 local TXT = "*Group Settings Ban*\n======================\n*Ban all* : "..mute_all.."\n" .."*Ban Links* : "..mute_links.."\n" .."*Ban Inline* : "..mute_in.."\n" .."*Ban English* : "..lock_english.."\n" .."*Ban Forward* : "..lock_forward.."\n" .."*Ban Arabic* : "..lock_arabic.."\n" .."*Ban Hashtag* : "..lock_htag.."\n".."*Ban tag* : "..lock_tag.."\n" .."*Ban Webpage* : "..lock_wp.."\n" .."*Ban Location* : "..lock_location.."\n"
.."*Ban Photo* : "..mute_photo.."\n" .."*Ban video note* : "..mute_note.."\n" .."*Ban Text* : "..mute_text.."\n" .."*Ban Gifs* : "..mute_gifs.."\n" .."*Ban Voice* : "..mute_voice.."\n" .."*Ban Music* : "..mute_music.."\n" .."*Ban Video* : "..mute_video.."\n*Ban Cmd* : "..lock_cmd.."\n"  .."*Ban Markdown* : "..mute_mdd.."\n*Ban Document* : "..mute_doc.."\n"
.."*Expire* : "..exp_dat.."\n======================"
   send(msg.chat_id_, msg.id_, 1, TXT, 1, 'md')
end

local text = msg.content_.text_:gsub('اعدادات الطرد','sdd3')
  	 if text:match("^[Ss][Dd][Dd]3$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	if database:get('bot:muteallban'..msg.chat_id_) then
	mute_all = '`مفعل | 🔐`'
else
mute_all = '✖️┇'
end
------------
if database:get('bot:text:ban'..msg.chat_id_) then
mute_text = '✔️┇'
else
mute_text = '✖️┇'
end

if database:get('bot:note:ban'..msg.chat_id_) then
mute_note = '✔️┇'
else
mute_note = '✖️┇'
end
------------
if database:get('bot:photo:ban'..msg.chat_id_) then
mute_photo = '✔️┇'
else
mute_photo = '✖️┇'
end
------------
if database:get('bot:video:ban'..msg.chat_id_) then
mute_video = '✔️┇'
else
mute_video = '✖️┇'
end
------------
if database:get('bot:gifs:ban'..msg.chat_id_) then
mute_gifs = '✔️┇'
else
mute_gifs = '✖️┇'
end
------------
if database:get('bot:music:ban'..msg.chat_id_) then
mute_music = '✔️┇'
else
mute_music = '✖️┇'
end
------------
if database:get('bot:inline:ban'..msg.chat_id_) then
mute_in = '✔️┇'
else
mute_in = '✖️┇'
end
------------
if database:get('bot:voice:ban'..msg.chat_id_) then
mute_voice = '✔️┇'
else
mute_voice = '✖️┇'
end
  ------------
if database:get('bot:links:ban'..msg.chat_id_) then
mute_links = '✔️┇'
else
mute_links = '✖️┇'
end
  ------------
if database:get('bot:sticker:ban'..msg.chat_id_) then
lock_sticker = '✔️┇'
else
lock_sticker = '✖️┇'
end
------------
 if database:get('bot:cmd:ban'..msg.chat_id_) then
lock_cmd = '✔️┇'
else
lock_cmd = '✖️┇'
end

  if database:get('bot:webpage:ban'..msg.chat_id_) then
lock_wp = '✔️┇'
else
lock_wp = '✖️┇'
end
------------
  if database:get('bot:hashtag:ban'..msg.chat_id_) then
lock_htag = '✔️┇'
else
lock_htag = '✖️┇'
end
------------
  if database:get('bot:tag:ban'..msg.chat_id_) then
lock_tag = '✔️┇'
else
lock_tag = '✖️┇'
end
------------
  if database:get('bot:location:ban'..msg.chat_id_) then
lock_location = '✔️┇'
else
lock_location = '✖️┇'
end
------------
  if database:get('bot:contact:ban'..msg.chat_id_) then
lock_contact = '✔️┇'
else
lock_contact = '✖️┇'
end
------------
  if database:get('bot:english:ban'..msg.chat_id_) then
lock_english = '✔️┇'
else
lock_english = '✖️┇'
end
------------
  if database:get('bot:arabic:ban'..msg.chat_id_) then
lock_arabic = '✔️┇'
else
lock_arabic = '✖️┇'
end
------------
  if database:get('bot:forward:ban'..msg.chat_id_) then
lock_forward = '✔️┇'
else
lock_forward = '✖️┇'
end

if database:get('bot:document:ban'..msg.chat_id_) then
mute_doc = '✔️┇'
else
mute_doc = '✖️┇'
end

if database:get('bot:markdown:ban'..msg.chat_id_) then
mute_mdd = '✔️┇'
else
mute_mdd = '✖️┇'
end
	------------
	------------
	local ex = database:ttl("bot:charge:"..msg.chat_id_)
if ex == -1 then
exp_dat = '`لا نهائي`'
else
exp_dat = math.floor(ex / 86400) + 1
			end
 	------------
	  local TXT = "🗑┇اعدادات المجموعه بالطرد\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n✔️┇~⪼ مفعل\n✖️┇~⪼ معطل\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
..mute_all.."كل الوسائط".."\n"
..mute_links.." الروابط".."\n"
..mute_in.." الانلاين".."\n"
..lock_english.." اللغه الانكليزيه".."\n"
..lock_forward.." اعاده التوجيه".."\n"
..lock_arabic.." اللغه العربيه".."\n\n"
..lock_htag.." التاكات".."\n"
..lock_tag.." المعرفات".."\n"
..lock_wp.." المواقع".."\n"
..lock_location.." الشبكات".."\n"
..mute_spam.." الكلايش".."\n"
..mute_photo.." الصور".."\n\n"
..mute_note.." بصمه الفيديو".."\n\n"
..mute_text.." الدردشه".."\n"
..mute_gifs.." الصور المتحركه".."\n"
..lock_sticker.." الملصقات".."\n"
..lock_contact.." جهات الاتصال".."\n"
..mute_voice.." الصوتيات".."\n"
..mute_music.." الاغاني".."\n\n"
..mute_video.." الفيديوهات".."\n"
..lock_cmd.." الشارحه".."\n"
..mute_mdd.." الماركدون".."\n"
..mute_doc.." الملفات".."\n"
.."┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
..exp_dat.." انقضاء البوت".." يوم\n"
.."┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
  send(msg.chat_id_, msg.id_, 1, TXT, 1, 'md')
   end
  -----------------------------------------------------------------------------------------------
if text == 'change dev text' or text == 'تغير امر المطور بالكليشه' and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '<code» send the</code> <b>help</b>', 1, 'html')
else
send(msg.chat_id_, msg.id_, 1, '📥┇الان يمكنك ارسال الكليشه  ليتم حفظها', 1, 'html')
end
redis:set('texts'..msg.sender_user_id_..''..bot_id, 'msg')
  return false end
if text:match("^(.*)$") then
local keko2 = redis:get('texts'..msg.sender_user_id_..''..bot_id)
if keko2 == 'msg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '<code» Saved Send a</code> <b>help to watch the changes</b>', 1, 'html')
else
send(msg.chat_id_, msg.id_, 1, '☑️┇تم حفظ الكليشه يمكنك اظهارها بارسال الامر', 1, 'html')
end
redis:set('texts'..msg.sender_user_id_..''..bot_id, 'no')
redis:set('text_sudo'..bot_id, text)
send(msg.chat_id_, msg.id_, 1, text , 1, 'html')
  return false end
 end
if text == 'del dev text' or text == 'مسح امر المطور بالكليشه' and tonumber(msg.sender_user_id_) == tonumber(sudo_add)  then
 redis:del('text_sudo'..bot_id, text)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '<b>Deleted</b>', 1, 'html')
else
 send(msg.chat_id_, msg.id_, 1, '☑┇تم حذف الكليشه ', 1, 'html')
  end
  end
if text:match("^[Dd][Ee][Vv]$")or text:match("^مطور بوت$") or text:match("^مطورين$") or text:match("^مطور البوت$") or text:match("^مطور$") or text:match("^المطور$") and msg.reply_to_message_id_ == 0 then
  local text_sudo = redis:get('text_sudo'..bot_id)
  local lkeko = redis:get('nmkeko'..bot_id)
  if text_sudo then
  send(msg.chat_id_, msg.id_, 1, text_sudo, 1, 'md')
  else
  local nakeko = redis:get('nakeko'..bot_id)
  sendContact(msg.chat_id_, msg.id_, 0, 1, nil, (nkeko or 9647707641864), (nakeko or "TshAke TEAM"), "", bot_id)
end
 end
  for k,v in pairs(sudo_users) do
local text = msg.content_.text_:gsub('تغير امر المطور','change ph')
if text:match("^[Cc][Hh][Aa][Nn][Gg][Ee] [Pp][Hh]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Now send the_ *developer number*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '• `الان يمكنك ارسال رقم المطور` 🗳', 1, 'md')
end
redis:set('nkeko'..msg.sender_user_id_..''..bot_id, 'msg')
  return false end
end
if text:match("^+(.*)$") then
local kekoo = redis:get('sudoo'..text..''..bot_id)
local keko2 = redis:get('nkeko'..msg.sender_user_id_..''..bot_id)
if keko2 == 'msg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Now send the_ *name of the developer*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '• `الان يمكنك ارسال الاسم الذي تريده` 🏷', 1, 'md')
end
redis:set('nmkeko'..bot_id, text)
redis:set('nkeko'..msg.sender_user_id_..''..bot_id, 'mmsg')
  return false end
end
if text:match("^(.*)$") then
local keko2 = redis:get('nkeko'..msg.sender_user_id_..''..bot_id)
if keko2 == 'mmsg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Saved Send a_ *DEV to watch the changes*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '• `تم حفظ الاسم يمكنك اظهار الجه بـ ارسال امر المطور` ☑️', 1, 'md')
end
redis:set('nkeko'..msg.sender_user_id_..''..bot_id, 'no')
redis:set('nakeko'..bot_id, text)
local nmkeko = redis:get('nmkeko'..bot_id)
sendContact(msg.chat_id_, msg.id_, 0, 1, nil, nmkeko, text , "", bot_id)
  return false end
end
  for k,v in pairs(sudo_users) do
local text = msg.content_.text_:gsub('اضف مطور','add sudo')
if text:match("^[Aa][Dd][Dd] [Ss][Uu][Dd][Oo]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Send ID_ *Developer*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '📥┇الان يمكنك ارسال ايدي المطور الذي تريد رفعه', 1, 'md')
end
redis:set('qkeko'..msg.sender_user_id_..''..bot_id, 'msg')
  return false end
end
if text:match("^(%d+)$") then
local kekoo = redis:get('sudoo'..text..''..bot_id)
local keko2 = redis:get('qkeko'..msg.sender_user_id_..''..bot_id)
if keko2 == 'msg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Has been added_ '..text..' *Developer of bot*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم اضافته ('..text..') مطور للبوت', 1, 'md')
end
redis:set('sudoo'..text..''..bot_id, 'yes')
redis:sadd('dev'..bot_id, text)
redis:set('qkeko'..msg.sender_user_id_..''..bot_id, 'no')
  return false end
end

  for k,v in pairs(sudo_users) do
local text = msg.content_.text_:gsub('حذف مطور','rem sudo')
if text:match("^[Rr][Ee][Mm] [Ss][Uu][Dd][Oo]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Send ID_ *Developer*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '📥┇الان يمكنك ارسال ايدي المطور الذي تريد حذفه', 1, 'md')
end
redis:set('xkeko'..msg.sender_user_id_..''..bot_id, 'nomsg')
  return false end
end
if text:match("^(%d+)$") then
local keko2 = redis:get('xkeko'..msg.sender_user_id_..''..bot_id)
if keko2 == 'nomsg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Has been removed_ '..text..' *Developer of bot*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم حذفه ('..text..') من مطورين البوت', 1, 'md')
end
redis:set('xkeko'..msg.sender_user_id_..''..bot_id, 'no')
redis:del('sudoo'..text..''..bot_id, 'no')
 end
end

local text = msg.content_.text_:gsub('اضف رد','add rep')
if text:match("^[Aa][Dd][Dd] [Rr][Ee][Pp]$") and is_owner(msg.sender_user_id_ , msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Send the word_ *you want to add*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '📥┇ارسل الكلمه التي تريد اضافتها', 1, 'md')
end
redis:set('keko1'..msg.sender_user_id_..''..bot_id..''..msg.chat_id_..'', 'msg')
  return false end
if text:match("^(.*)$") then
if not database:get('bot:repowner:mute'..msg.chat_id_) then
local keko = redis:get('keko'..text..''..bot_id..''..msg.chat_id_..'')
send(msg.chat_id_, msg.id_, 1, keko, 1, 'md')
end
local keko1 = redis:get('keko1'..msg.sender_user_id_..''..bot_id..''..msg.chat_id_..'')
if keko1 == 'msg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Send the reply_ *you want to add*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '📥┇الان ارسل الرد الذي تريد اضافته', 1, 'md')
end
redis:set('keko1'..msg.sender_user_id_..''..bot_id..''..msg.chat_id_..'', 're')
redis:set('msg'..msg.sender_user_id_..''..bot_id..''..msg.chat_id_..'', text)
redis:sadd('repowner'..msg.sender_user_id_..''..bot_id..''..msg.chat_id_..'', text)
  return false end
if keko1 == 're' then
local keko2 = redis:get('msg'..msg.sender_user_id_..''..bot_id..''..msg.chat_id_..'')
redis:set('keko'..keko2..''..bot_id..''..msg.chat_id_..'', text)
redis:sadd('kekore'..bot_id..''..msg.chat_id_..'', keko2)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Saved_', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "☑┇تم حفظ الرد", 1, 'md')
end
redis:set('keko1'..msg.sender_user_id_..''..bot_id..''..msg.chat_id_..'', 'no')
end
end

local text = msg.content_.text_:gsub('حذف رد','rem rep')
if text:match("^[Rr][Ee][Mm] [Rr][Ee][Pp]$") and is_owner(msg.sender_user_id_ , msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Send the word_ *you want to remov*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '📥┇ارسل الكلمه التي تريد حذفها', 1, 'md')
end
redis:set('keko1'..msg.sender_user_id_..''..bot_id..''..msg.chat_id_..'', 'nomsg')
  return false end
if text:match("^(.*)$") then
local keko1 = redis:get('keko1'..msg.sender_user_id_..''..bot_id..''..msg.chat_id_..'')
if keko1 == 'nomsg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Deleted_', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم حذف الرد', 1, 'md')
end
redis:set('keko1'..msg.sender_user_id_..''..bot_id..''..msg.chat_id_..'', 'no')
redis:set('keko'..text..''..bot_id..''..msg.chat_id_..'', " ")
 end
end

local text = msg.content_.text_:gsub('اضف رد للكل','add rep all')
if text:match("^[Aa][Dd][Dd] [Rr][Ee][Pp] [Aa][Ll][Ll]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add)  then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Send the word_ *you want to add*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '📥┇ارسل الكلمه التي تريد اضافته', 1, 'md')
end
redis:set('keko1'..msg.sender_user_id_..''..bot_id, 'msg')
  return false end
if text:match("^(.*)$") then
if not database:get('bot:repsudo:mute'..msg.chat_id_) then
local keko = redis:get('keko'..text..''..bot_id)
send(msg.chat_id_, msg.id_, 1, keko, 1, 'md')
end
local keko1 = redis:get('keko1'..msg.sender_user_id_..''..bot_id)
if keko1 == 'msg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Send the reply_ *you want to add*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '📥┇الان ارسل الرد الذي تريد اضافته', 1, 'md')
end
redis:set('keko1'..msg.sender_user_id_..''..bot_id, 're')
redis:set('msg'..msg.sender_user_id_..''..bot_id, text)
  return false end
if keko1 == 're' then
local keko2 = redis:get('msg'..msg.sender_user_id_..''..bot_id)
redis:set('keko'..keko2..''..bot_id, text)
redis:sadd('kekoresudo'..bot_id, keko2)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Saved_', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "☑┇تم حفظ الرد", 1, 'md')
end
redis:set('keko1'..msg.sender_user_id_..''..bot_id, 'no')
end
end

local text = msg.content_.text_:gsub('حذف رد للكل','rem rep all')
if text:match("^[Rr][Ee][Mm] [Rr][Ee][Pp] [Aa][Ll][Ll]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add)  then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Send the word_ *you want to remov*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '📥┇ارسل الكلمه التي تريد حذفها' , 1, 'md')
end
redis:set('keko1'..msg.sender_user_id_..''..bot_id, 'nomsg')
  return false end
if text:match("^(.*)$") then
local keko1 = redis:get('keko1'..msg.sender_user_id_..''..bot_id)
if keko1 == 'nomsg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Deleted_', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم حذف الرد', 1, 'md')
end
redis:set('keko1'..msg.sender_user_id_..''..bot_id, 'no')
 redis:set('keko'..text..''..bot_id..'', " ")
 end
end

local text = msg.content_.text_:gsub('مسح المطورين','clean sudo')
if text:match("^[Cc][Ll][Ee][Aa][Nn] [Ss][Uu][Dd][Oo]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
  local list = redis:smembers('dev'..bot_id)
  for k,v in pairs(list) do
redis:del('dev'..bot_id, text)
redis:del('sudoo'..v..''..bot_id, 'no')
end
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> Bot developers_ *have been cleared*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, "☑┇تم مسح مطورين البوت", 1, 'md')
end
  end

local text = msg.content_.text_:gsub('مسح ردود المدير','clean rep owner')
if text:match("^[Cc][Ll][Ee][Aa][Nn] [Rr][Ee][Pp] [Oo][Ww][Nn][Ee][Rr]$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
  local list = redis:smembers('kekore'..bot_id..''..msg.chat_id_..'')
  for k,v in pairs(list) do
redis:del('kekore'..bot_id..''..msg.chat_id_..'', text)
redis:set('keko'..v..''..bot_id..''..msg.chat_id_..'', " ")
end
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> Owner replies_ *cleared*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, "• `تم مسح ردود المدير` 🗑", 1, 'md')
end
  end

local text = msg.content_.text_:gsub('مسح ردود المطور','clean rep sudo')
if text:match("^[Cc][Ll][Ee][Aa][Nn] [Rr][Ee][Pp] [Ss][Uu][Dd][Oo]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add)  then
  local list = redis:smembers('kekoresudo'..bot_id)
  for k,v in pairs(list) do
redis:del('kekoresudo'..bot_id, text)
redis:set('keko'..v..''..bot_id..'', " ")
end
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '_> Sudo replies_ *cleared*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, "☑┇تم مسح ردود المطور", 1, 'md')
end
  end

local text = msg.content_.text_:gsub('المطورين','sudo list')
if text:match("^[Ss][Uu][Dd][Oo] [Ll][Ii][Ss][Tt]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
	local list = redis:smembers('dev'..bot_id)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>Sudo List :</b>\nֆ • • • • • • • • • • • • • ֆ\n• ✅ :- added\n• ❎ :- Deleted\nֆ • • • • • • • • • • • • • ֆ\n"
else
  text = "⛔┇قائمه المطورين  ،\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n✔┇تم رفعه مطور\n✖┇تم تنزيله من مطورين\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
  end
	for k,v in pairs(list) do
			local keko11 = redis:get('sudoo'..v..''..bot_id)
			local botlua = "✖"
 if keko11 == 'yes' then
 botlua = "✔"
  if database:get('bot:lang:'..msg.chat_id_) then
			text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼(<code>"..v.."</code>)\n"
   else
text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼(<code>"..v.."</code>)\n"
			end

		else
  if database:get('bot:lang:'..msg.chat_id_) then
		 text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼(<code>"..v.."</code>)\n"
  else
  text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼(<code>"..v.."</code>)\n"
			end
		end

	end
	if #list == 0 then
	   if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>Sudo List is empty !</b>"
  else
text = "• <code>لا يوجد مطورين</code> ⚠️"
end
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
-----------------------------------------

------------------------------------
local text = msg.content_.text_:gsub('ردود المطور','rep sudo list')
if text:match("^[Rr][Ee][Pp] [Ss][Uu][Dd][Oo] [Ll][Ii][Ss][Tt]$") and tonumber(msg.sender_user_id_) == tonumber(sudo_add)  then
	local list = redis:smembers('kekoresudo'..bot_id)
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>rep sudo List :</b>\nֆ • • • • • • • • • • • • • ֆ\n• ✅ :- Enabled\n• ❎ :- Disabled\nֆ • • • • • • • • • • • • • ֆ\n"
else
  text = "📑┇قائمه ردود المطور\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n✔┇مفعله\n✖┇معطله\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
  end
	for k,v in pairs(list) do
  local keko11 = redis:get('keko'..v..''..bot_id)
			local botlua = "✔┇"
   if keko11 == ' ' then
   botlua = "✖┇"
  if database:get('bot:lang:'..msg.chat_id_) then
  text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼(<code>"..v.."</code>)\n"
  else
  text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼("..v..")\n"
			end
		else
  if database:get('bot:lang:'..msg.chat_id_) then
text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼(<code>"..v.."</code>)\n"
else
text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼("..v..")\n"
			end
		end
	end
	if #list == 0 then
	   if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>rep owner List is empty !</b>"
  else
text = "❕┇لا يوجد ردود للمطور"
end
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end

local text = msg.content_.text_:gsub('ردود المدير','rep owner list')
if text:match("^[Rr][Ee][Pp] [Oo][Ww][Nn][Ee][Rr] [Ll][Ii][Ss][Tt]$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
  local list = redis:smembers('kekore'..bot_id..''..msg.chat_id_..'')
  if database:get('bot:lang:'..msg.chat_id_) then
  text = "<b>rep owner List :</b>\nֆ • • • • • • • • • • • • • ֆ\n• ✅ :- Enabled\n• ❎ :- Disabled\nֆ • • • • • • • • • • • • • ֆ\n"
else
  text = "📑┇قائمه ردود المدير\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n✔┇مفعله\n✖┇معطله\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
  end
	for k,v in pairs(list) do
local keko11 = redis:get('keko'..v..''..bot_id..''..msg.chat_id_..'')
			local botlua = "✔┇"
 if keko11 == ' ' then
 botlua = "✖┇"
  if database:get('bot:lang:'..msg.chat_id_) then
text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼(<code>"..v.."</code>)\n"
 else
  text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼("..v..")\n"
			end
		else
  if database:get('bot:lang:'..msg.chat_id_) then
text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼(<code>"..v.."</code>)\n"
 else
  text = text.."<b>|"..k.."|</b>"..botlua.." ~⪼("..v..")\n"
			end
		end
	end
	if #list == 0 then
	   if database:get('bot:lang:'..msg.chat_id_) then
text = "<b>rep owner List is empty !</b>"
  else
text = "❕┇لا يوجد ردود للمدير"
end
end
	send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('كرر','echo')
  	if text:match("^echo (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local txt = {string.match(text, "^(echo) (.*)$")}
   send(msg.chat_id_, msg.id_, 1, txt[2], 1, 'html')
end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('وضع قوانين','setrules')
  	if text:match("^[Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss] (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
	local txt = {string.match(text, "^([Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss]) (.*)$")}
	database:set('bot:rules'..msg.chat_id_, txt[2])
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, "*> Group rules upadted..._", 1, 'md')
   else
   send(msg.chat_id_, msg.id_, 1, "✔┇تم وضع القوانين للمجموعه", 1, 'md')
end
  end


	-----------------------------------------------------------------------------------------------
  	if text:match("^[Rr][Uu][Ll][Ee][Ss]$")or text:match("^القوانين$") then
	local rules = database:get('bot:rules'..msg.chat_id_)
	if rules then
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*Group Rules :*\n'..rules, 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '⚜┇قوانين المجموعه هي\n'..rules, 1, 'md')
end
else
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '*rules msg not saved!*', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '⚜┇لم يتم حفظ قوانين للمجموعه', 1, 'md')
end
	end
	end
	-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('وضع اسم','setname')
		if text:match("^[Ss][Ee][Tt][Nn][Aa][Mm][Ee] (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_)  then
	local txt = {string.match(text, "^([Ss][Ee][Tt][Nn][Aa][Mm][Ee]) (.*)$")}
	changetitle(msg.chat_id_, txt[2])
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_Group name updated!_\n'..txt[2], 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '✔┇تم تحديث اسم المجموعه الى \n'..txt[2], 1, 'md')
   end
end
	-----------------------------------------------------------------------------------------------

	if text:match("^[Ss][Ee][Tt][Pp][Hh][Oo][Tt][Oo]$") or text:match("^وضع صوره") and is_mod(msg.sender_user_id_, msg.chat_id_) then
database:set('bot:setphoto'..msg.chat_id_..':'..msg.sender_user_id_,true)
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_Please send a photo noew!_', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '📥┇قم بارسال صوره الان', 1, 'md')
end
end

   local text = msg.content_.text_:gsub('وضع وصف','setabout')
       if text:match("^[Ss][Ee][Tt][Aa][Bb][Oo][Uu][Tt] (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
       local text = {string.match(text, "^([Ss][Ee][Tt][Aa][Bb][Oo][Uu][Tt]) (.*)$")}
       local url = 'https://api.telegram.org/bot' .. token .. '/setChatDescription?chat_id='..msg.chat_id_..'&description='..text[2]
       https.request(url)

       if database:get('bot:lang:'..msg.chat_id_) then
                  send(msg.chat_id_, msg.id_, 1, "*> Group About Upadted..._", 1, 'md')
                  else
                  send(msg.chat_id_, msg.id_, 1, "✔️┇تم وضع وصف للمجموعه", 1, 'md')
               end
   end
-----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('وضع وقت','setexpire')
	if text:match("^[Ss][Ee][Tt][Ee][Xx][Pp][Ii][Rr][Ee] (%d+)$") and is_sudo(msg) then
		local a = {string.match(text, "^([Ss][Ee][Tt][Ee][Xx][Pp][Ii][Rr][Ee]) (%d+)$")}
		 local time = a[2] * day
   database:setex("bot:charge:"..msg.chat_id_,time,true)
		 database:set("bot:enable:"..msg.chat_id_,true)
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_Group Charged for_ *'..a[2]..'* _Days_', 1, 'md')
else
   send(msg.chat_id_, msg.id_, 1, '🔘┇تم وضع وقت انتهاء البوت *{'..a[2]..'}* يوم', 1, 'md')
end
  end

	-----------------------------------------------------------------------------------------------
	if text:match("^[Ss][Tt][Aa][Tt][Ss]$") or text:match("^الوقت$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
local ex = database:ttl("bot:charge:"..msg.chat_id_)
 if ex == -1 then
if database:get('bot:lang:'..msg.chat_id_) then
		send(msg.chat_id_, msg.id_, 1, '_No fanil_', 1, 'md')
else
		send(msg.chat_id_, msg.id_, 1, '🔘┇وقت المجموعه لا نهائي` ☑️', 1, 'md')
end
 else
  local d = math.floor(ex / day ) + 1
if database:get('bot:lang:'..msg.chat_id_) then
	   		send(msg.chat_id_, msg.id_, 1, d.." *Group Days*", 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, "❕┇عدد ايام وقت المجموعه️ {"..d.."} يوم", 1, 'md')
end
 end
end
	-----------------------------------------------------------------------------------------------

	if text:match("^وقت المجموعه (-%d+)$") and is_sudo(msg) then
	local txt = {string.match(text, "^(وقت المجموعه) (-%d+)$")}
local ex = database:ttl("bot:charge:"..txt[2])
 if ex == -1 then
		send(msg.chat_id_, msg.id_, 1, '🔘┇وقت المجموعه لا نهائي', 1, 'md')
 else
  local d = math.floor(ex / day ) + 1
send(msg.chat_id_, msg.id_, 1, "❕┇عدد ايام وقت المجموعه {"..d.."} يوم", 1, 'md')
 end
end

	if text:match("^[Ss][Tt][Aa][Tt][Ss] [Gg][Pp] (-%d+)") and is_sudo(msg) then
	local txt = {string.match(text, "^([Ss][Tt][Aa][Tt][Ss] [Gg][Pp]) (-%d+)$")}
local ex = database:ttl("bot:charge:"..txt[2])
 if ex == -1 then
		send(msg.chat_id_, msg.id_, 1, '_No fanil_', 1, 'md')
 else
  local d = math.floor(ex / day ) + 1
	   		send(msg.chat_id_, msg.id_, 1, d.." *Group is Days*", 1, 'md')
 end
end
	-----------------------------------------------------------------------------------------------
	 if is_sudo(msg) then
  -----------------------------------------------------------------------------------------------
  if text:match("^[Ll][Ee][Aa][Vv][Ee] (-%d+)$") and is_sudo(msg) then
  	local txt = {string.match(text, "^([Ll][Ee][Aa][Vv][Ee]) (-%d+)$")}
	   send(msg.chat_id_, msg.id_, 1, '*Group* '..txt[2]..' *remov*', 1, 'md')
	   send(txt[2], 0, 1, '*Error*\n_Group is not my_', 1, 'md')
	   chat_leave(txt[2], bot_id)
  end

  if text:match("^مغادره (-%d+)$") and is_sudo(msg) then
  	local txt = {string.match(text, "^(مغادره) (-%d+)$")}
	   send(msg.chat_id_, msg.id_, 1, '🔘┇المجموعه {'..txt[2]..'} تم الخروج منها', 1, 'md')
	   send(txt[2], 0, 1, '❕┇هذه ليست ضمن المجموعات الخاصة بي', 1, 'md')
	   chat_leave(txt[2], bot_id)
  end
  -----------------------------------------------------------------------------------------------
  if text:match('^المده1 (-%d+)$') and is_sudo(msg) then
 local txt = {string.match(text, "^(المده1) (-%d+)$")}
 local timeplan1 = 2592000
 database:setex("bot:charge:"..txt[2],timeplan1,true)
	   send(msg.chat_id_, msg.id_, 1, '☑┇المجموعه ('..txt[2]..') تم اعادة تفعيلها المدة 30 يوم', 1, 'md')
	 send(txt[2], 0, 1, '☑┇تم تفعيل مدة المجموعه 30 يوم', 1, 'md')
	   for k,v in pairs(sudo_users) do
 send(v, 0, 1, "🔘┇قام بتفعيل مجموعه المده كانت 30 يوم \n🎫┇ايدي المطور ~⪼ ("..msg.sender_user_id_..")\n📜┇معرف المطور ~⪼ ("..get_info(msg.sender_user_id_)..")\n🌐┇معلومات المجموعه \n\n🎫┇ايدي المجموعه ~⪼ ("..msg.chat_id_..")\nⓂ┇اسم المجموعه ~⪼ ("..chat.title_..")" , 1, 'md')
 end
	   database:set("bot:enable:"..txt[2],true)
  end
  -----------------------------------------------------------------------------------------------
  if text:match('^[Pp][Ll][Aa][Nn]1 (-%d+)$') and is_sudo(msg) then
 local txt = {string.match(text, "^([Pp][Ll][Aa][Nn]1) (-%d+)$")}
 local timeplan1 = 2592000
 database:setex("bot:charge:"..txt[2],timeplan1,true)
	   send(msg.chat_id_, msg.id_, 1, '_Group_ '..txt[2]..' *Done 30 Days Active*', 1, 'md')
	   send(txt[2], 0, 1, '*Done 30 Days Active*', 1, 'md')
	   for k,v in pairs(sudo_users) do
	send(v, 0, 1, "*User "..msg.sender_user_id_.." Added bot to new group*" , 1, 'md')
 end
	   database:set("bot:enable:"..txt[2],true)
  end
  -----------------------------------------------------------------------------------------------
  if text:match('^المده2 (-%d+)$') and is_sudo(msg) then
 local txt = {string.match(text, "^(المده2) (-%d+)$")}
 local timeplan2 = 7776000
 database:setex("bot:charge:"..txt[2],timeplan2,true)
	   send(msg.chat_id_, msg.id_, 1, '☑┇المجموعه ('..txt[2]..') تم اعادة تفعيلها المدة 90 يوم', 1, 'md')
	   send(txt[2], 0, 1, '☑┇تم تفعيل مدة المجموعه 90 يوم', 1, 'md')
	   for k,v in pairs(sudo_users) do
 send(v, 0, 1, "🔘┇قام بتفعيل مجموعه المده كانت 90 يوم \n🎫┇ايدي المطور ~⪼ ("..msg.sender_user_id_..")\n📜┇معرف المطور ~⪼ ("..get_info(msg.sender_user_id_)..")\n🌐┇معلومات المجموعه \n\n🎫┇ايدي المجموعه ~⪼ ("..msg.chat_id_..")\nⓂ┇اسم المجموعه ~⪼ ("..chat.title_..")" , 1, 'md')
 end
	   database:set("bot:enable:"..txt[2],true)
  end
-------------------------------------------------------------------------------------------------
  if text:match('^[Pp][Ll][Aa][Nn]2 (-%d+)$') and is_sudo(msg) then
 local txt = {string.match(text, "^([Pp][Ll][Aa][Nn]2) (-%d+)$")}
 local timeplan2 = 7776000
 database:setex("bot:charge:"..txt[2],timeplan2,true)
	   send(msg.chat_id_, msg.id_, 1, '_Group_ '..txt[2]..' *Done 90 Days Active*', 1, 'md')
	   send(txt[2], 0, 1, '*Done 90 Days Active*', 1, 'md')
	   for k,v in pairs(sudo_users) do
	send(v, 0, 1, "*User "..msg.sender_user_id_.." Added bot to new group*" , 1, 'md')
 end
	   database:set("bot:enable:"..txt[2],true)
  end
  -----------------------------------------------------------------------------------------------
  if text:match('^المده3 (-%d+)$') and is_sudo(msg) then
 local txt = {string.match(text, "^(المده3) (-%d+)$")}
 database:set("bot:charge:"..txt[2],true)
	   send(msg.chat_id_, msg.id_, 1, '☑┇المجموعه ('..txt[2]..') تم اعادة تفعيلها المدة لا نهائية', 1, 'md')
	   send(txt[2], 0, 1, '☑┇تم تفعيل مدة المجموعه لا نهائية', 1, 'md')
	   for k,v in pairs(sudo_users) do
send(v, 0, 1, "🔘┇قام بتفعيل مجموعه المده كانت لا نهائية \n🎫┇ايدي المطور ~⪼ ("..msg.sender_user_id_..")\n📜┇معرف المطور ~⪼ ("..get_info(msg.sender_user_id_)..")\n🌐┇معلومات المجموعه \n\n🎫┇ايدي المجموعه ~⪼ ("..msg.chat_id_..")\nⓂ┇اسم المجموعه ~⪼ ("..chat.title_..")" , 1, 'md')
 end
	   database:set("bot:enable:"..txt[2],true)
  end
  -----------------------------------------------------------------------------------------------
  if text:match('^[Pp][Ll][Aa][Nn]3 (-%d+)$') and is_sudo(msg) then
 local txt = {string.match(text, "^([Pp][Ll][Aa][Nn]3) (-%d+)$")}
 database:set("bot:charge:"..txt[2],true)
	   send(msg.chat_id_, msg.id_, 1, '_Group_ '..txt[2]..' *Done Days No Fanil Active*', 1, 'md')
	   send(txt[2], 0, 1, '*Done Days No Fanil Active*', 1, 'md')
	   for k,v in pairs(sudo_users) do
	send(v, 0, 1, "*User "..msg.sender_user_id_.." Added bot to new group*" , 1, 'md')
 end
	   database:set("bot:enable:"..txt[2],true)
  end
  -----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('تفعيل','add')
  if text:match('^[Aa][Dd][Dd]$') and is_sudo(msg) then
local keko222 = 'https://tshake.tk/TshakeApi/ch.php?id='..msg.sender_user_id_..''
    local ress = https.request(keko222)
if ress then
    if ress ~= 'on' then
    print(ress)
    send(msg.chat_id_, msg.id_, 1, ress, 1, 'md')
return false end
end
  local txt = {string.match(text, "^([Aa][Dd][Dd])$")}
  if database:get("bot:charge:"..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '*Bot is already Added Group*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, "❕┇المجموعه {"..chat.title_.."} مفعله سابقا", 1, 'md')
end
  end
 if not database:get("bot:charge:"..msg.chat_id_) then
 database:set("bot:charge:"..msg.chat_id_,true)
if database:get('bot:lang:'..msg.chat_id_) then
	   send(msg.chat_id_, msg.id_, 1, "*> Your ID :* _"..msg.sender_user_id_.."_\n*> Bot Added To Group*", 1, 'md')
   else
  send(msg.chat_id_, msg.id_, 1, "🎫┇ايديك ~⪼ ("..msg.sender_user_id_..")\n☑┇تم تفعيل المجموعه {"..chat.title_.."}", 1, 'md')
end
	   for k,v in pairs(sudo_users) do
if database:get('bot:lang:'..msg.chat_id_) then
	send(v, 0, 1, "*> Your ID :* _"..msg.sender_user_id_.."_\n*> added bot to new group*" , 1, 'md')
else
send(v, 0, 1, "🔘┇قام بتفعيل مجموعه جديده \n🎫┇ايدي المطور ~⪼ ("..msg.sender_user_id_..")\n📜┇معرف المطور ~⪼ ("..get_info(msg.sender_user_id_)..")\n🌐┇معلومات المجموعه \n\n🎫┇ايدي المجموعه ~⪼ ("..msg.chat_id_..")\nⓂ┇اسم المجموعه ~⪼ ("..chat.title_..")" , 1, 'md')
end
 end
	   database:set("bot:enable:"..msg.chat_id_,true)
  end
end
  -----------------------------------------------------------------------------------------------
local text = msg.content_.text_:gsub('تعطيل','rem')
  if text:match('^[Rr][Ee][Mm]$') and is_sudo(msg) then
 local txt = {string.match(text, "^([Rr][Ee][Mm])$")}
if not database:get("bot:charge:"..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '*Bot is already remove Group*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, "❕┇المجموعه {"..chat.title_.."} معطله سابقا", 1, 'md')
end
  end
if database:get("bot:charge:"..msg.chat_id_) then
 database:del("bot:charge:"..msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
	   send(msg.chat_id_, msg.id_, 1, "*> Your ID :* _"..msg.sender_user_id_.."_\n*> Bot Removed To Group!*", 1, 'md')
   else
  send(msg.chat_id_, msg.id_, 1, "🎫┇ايديك ~⪼ ("..msg.sender_user_id_..")\n☑┇تم تعطيل المجموعه {"..chat.title_.."}", 1, 'md')
end
	   for k,v in pairs(sudo_users) do
if database:get('bot:lang:'..msg.chat_id_) then
	send(v, 0, 1, "*> Your ID :* _"..msg.sender_user_id_.."_\n*> Removed bot from new group*" , 1, 'md')
else
send(v, 0, 1, "🔘┇قام بتعطيل مجموعه \n🎫┇ايدي المطور ~⪼ ("..msg.sender_user_id_..")\n📜┇معرف المطور ~⪼ ("..get_info(msg.sender_user_id_)..")\n🌐┇معلومات المجموعه \n\n🎫┇ايدي المجموعه ~⪼ ("..msg.chat_id_..")\nⓂ┇اسم المجموعه ~⪼ ("..chat.title_..")" , 1, 'md')
end
 end
  end
  end

  -----------------------------------------------------------------------------------------------
if text:match('^[Jj][Oo][Ii][Nn] (-%d+)') and is_sudo(msg) then
   local txt = {string.match(text, "^([Jj][Oo][Ii][Nn]) (-%d+)$")}
  	   send(msg.chat_id_, msg.id_, 1, '_Group_ '..txt[2]..' *is join*', 1, 'md')
  	   send(txt[2], 0, 1, '*Sudo Joined To Grpup*', 1, 'md')
  	   add_user(txt[2], msg.sender_user_id_, 10)
end
-----------------------------------------------------------------------------------------------
  end
	-----------------------------------------------------------------------------------------------
if text:match("^[Dd][Ee][Ll]$")  and is_mod(msg.sender_user_id_, msg.chat_id_) or text:match("^مسح$") and msg.reply_to_message_id_ ~= 0 and is_mod(msg.sender_user_id_, msg.chat_id_) then
delete_msg(msg.chat_id_, {[0] = msg.reply_to_message_id_})
delete_msg(msg.chat_id_, {[0] = msg.id_})
end
	----------------------------------------------------------------------------------------------
   if text:match('^تنظيف (%d+)$') and is_owner(msg.sender_user_id_, msg.chat_id_) then
  local matches = {string.match(text, "^(تنظيف) (%d+)$")}
   if msg.chat_id_:match("^-100") then
if tonumber(matches[2]) > 100 or tonumber(matches[2]) < 1 then
pm = '❕┇لا تستطيع حذف اكثر من 100 رساله'
send(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
  else
tdcli_function ({
ID = "GetChatHistory",
 chat_id_ = msg.chat_id_,
from_message_id_ = 0,
   offset_ = 0,
limit_ = tonumber(matches[2])}, delmsg, nil)
pm ='☑┇تم <b>{'..matches[2]..'}</b> من الرسائل\n🗑┇حذفها'
send(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
 end
  else pm ='❕┇هناك خطاء'
send(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
  end
end


   if text:match('^[Dd]el (%d+)$') and is_owner(msg.sender_user_id_, msg.chat_id_) then
  local matches = {string.match(text, "^([Dd]el) (%d+)$")}
   if msg.chat_id_:match("^-100") then
if tonumber(matches[2]) > 100 or tonumber(matches[2]) < 1 then
pm = '<b>> Error</b>\n<b>use /del [1-1000] !<bb>'
send(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
  else
tdcli_function ({
ID = "GetChatHistory",
 chat_id_ = msg.chat_id_,
from_message_id_ = 0,
   offset_ = 0,
limit_ = tonumber(matches[2])
}, delmsg, nil)
pm ='> <i>'..matches[2]..'</i> <b>Last Msgs Has Been Removed.</b>'
send(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
 end
  else pm ='<b>> found!<b>'
send(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
end
  end


  if text:match("^[Ss][Ee][Tt][Ll][Aa][Nn][Gg] (.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) or text:match("^تحويل (.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
local langs = {string.match(text, "^(.*) (.*)$")}
  if langs[2] == "ar" or langs[2] == "عربيه" then
  if not database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '☑┇بالفعل تم وضع اللغه العربيه للبوت', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم وضع اللغه العربيه للبوت في المجموعه', 1, 'md')
 database:del('bot:lang:'..msg.chat_id_)
end
end
  if langs[2] == "en" or langs[2] == "انكليزيه" then
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '_> Language Bot is already_ *English*', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '> _Language Bot has been changed to_ *English* !', 1, 'md')
  database:set('bot:lang:'..msg.chat_id_,true)
end
end
end
----------------------------------------------------------------------------------------------

  if text == "enable reply bot" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Enable Reply bot" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تفعيل ردود البوت" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if not database:get('bot:rep:mute'..msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies bot is already enabled*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇ردود البوت بالفعل تم تفعيلها', 1, 'md')
end
  else
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies bot has been enable*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل ردود البوت', 1, 'md')
 database:del('bot:rep:mute'..msg.chat_id_)
end
end
end
  if text == "disable reply bot" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Disable Reply bot" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تعطيل ردود البوت" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:rep:mute'..msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies bot is already disabled*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇ردود البوت بالفعل تم تعطيلها', 1, 'md')
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies bot has been disable*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم تعطيل ردود البوت', 1, 'md')
  database:set('bot:rep:mute'..msg.chat_id_,true)
end
end
  end

if text == "enable id photo" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Enable id photo" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تفعيل الايدي بالصوره" and is_owner(msg.sender_user_id_, msg.chat_id_) then
if not database:get('bot:id:photo'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *id photo bot is already enabled*️', 1, 'md')
  else
  send(msg.chat_id_, msg.id_, 1, '☑┇الايدي بالصوره بالفعل تم تفعيله', 1, 'md')
  end
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *id photo bot has been enable*️', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل الايدي بالصوره', 1, 'md')
   database:del('bot:id:photo'..msg.chat_id_)
  end
end
end
if text == "disable id photo" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Disable id photo" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تعطيل الايدي بالصوره" and is_owner(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:id:photo'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *id photo bot is already disabled*️', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '☑┇الايدي بالصوره بالفعل تم تعطيله', 1, 'md')
  end
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *id photo bot has been disable*️', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '☑┇تم تعطيل الايدي بالصوره', 1, 'md')
database:set('bot:id:photo'..msg.chat_id_,true)
  end
end
end

if text == "enable bc" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or text == "Enable Bc" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or text == "تفعيل الاذاعه" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if not database:get('bot:bc:groups') then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *bc bot is already enabled*️', 1, 'md')
  else
  send(msg.chat_id_, msg.id_, 1, '☑┇الاذاعه بالفعل تم تفعيلها', 1, 'md')
  end
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *bc bot has been enable*️', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل اذاعه البوت', 1, 'md')
   database:del('bot:bc:groups')
  end
end
end
if text == "disable bc" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or text == "Disable Bc" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or text == "تعطيل الاذاعه" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:bc:groups') then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *bc bot is already disabled*️', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '☑┇الاذاعه بالفعل تم تعطيلها', 1, 'md')
  end
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *bc bot has been disable*️', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '☑┇تم تعطيل اذاعه البوت', 1, 'md')
database:set('bot:bc:groups',true)
  end
end
end

if text == "enable leave" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or text == "Enable Leave" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or text == "تفعيل المغادره" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if not database:get('bot:leave:groups') then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *leave bot is already enabled*️', 1, 'md')
  else
  send(msg.chat_id_, msg.id_, 1, '☑┇مغادره بالفعل تم تفعيلها', 1, 'md')
  end
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *leave bot has been enable*️', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل مغادره البوت', 1, 'md')
   database:del('bot:leave:groups'..msg.chat_id_)
  end
end
end
if text == "disable leave" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or text == "Disable Leave" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) or text == "تعطيل المغادره" and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:leave:groups') then
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *leave bot is already disabled*️', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '☑┇مغادره بالفعل تم تعطيلها', 1, 'md')
  end
else
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '> *leave bot has been disable*️', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '☑┇تم تعطيل مغادره البوت', 1, 'md')
database:set('bot:leave:groups'..msg.chat_id_,true)
  end
end
end
	-----------------------------------------------------------------------------------------------

  if text == "enable reply sudo" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Enable Reply sudo" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تفعيل ردود المطور" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if not database:get('bot:repsudo:mute'..msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies sudo is already enabled*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇ردود المطور بالفعل تم تفعيلها', 1, 'md')
end
  else
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies sudo has been enable*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل ردود المطور', 1, 'md')
 database:del('bot:repsudo:mute'..msg.chat_id_)
end
end
end
  if text == "disable reply sudo" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Disable Reply sudo" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تعطيل ردود المطور" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:repsudo:mute'..msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies sudo is already disabled*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇ردود المطور بالفعل تم تعطيلها', 1, 'md')
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies sudo has been disable*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, 'تم تعطيل ردود المطور', 1, 'md')
  database:set('bot:repsudo:mute'..msg.chat_id_,true)
end
end
  end

  if text == "enable reply owner" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Enable Reply owner" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تفعيل ردود المدير" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if not database:get('bot:repowner:mute'..msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies owner is already enabled*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇ردود المدير بالفعل تم تفعيلها', 1, 'md')
end
  else
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies owner has been enable*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل ردود المدير', 1, 'md')
 database:del('bot:repowner:mute'..msg.chat_id_)
end
end
end
  if text == "disable reply owner" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Disable Reply owner" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تعطيل ردود المدير" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:repowner:mute'..msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies owner is already disabled*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇ردود المدير بالفعل تم تعطيلها', 1, 'md')
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Replies owner has been disable*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم تعطيل ردود المدير', 1, 'md')
  database:set('bot:repowner:mute'..msg.chat_id_,true)
end
end
  end
	-----------------------------------------------------------------------------------------------
   if text:match("^[Ii][Dd][Gg][Pp]$") or text:match("^ايدي المجموعه$") then
send(msg.chat_id_, msg.id_, 1, "*"..msg.chat_id_.."*", 1, 'md')
  end
	-----------------------------------------------------------------------------------------------
  if text == "enable id" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Enable id" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تفعيل الايدي" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if not database:get('bot:id:mute'..msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *ID is already enabled*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇الايدي بالفعل تم تفعيله', 1, 'md')
end
  else
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *ID has been enable*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل الايدي', 1, 'md')
 database:del('bot:id:mute'..msg.chat_id_)
end
end
end
  if text == "disable id" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Disable id" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تعطيل الايدي" and is_owner(msg.sender_user_id_, msg.chat_id_) then
  if database:get('bot:id:mute'..msg.chat_id_) then
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *ID is already disabled*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇الايدي بالفعل تم تعطيله', 1, 'md')
end
else
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *ID has been disable*️', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم تعطيل الايدي', 1, 'md')
  database:set('bot:id:mute'..msg.chat_id_,true)
end
end
  end
	-----------------------------------------------------------------------------------------------
if  text:match("^[Ii][Dd]$") and msg.reply_to_message_id_ == 0 or text:match("^ايدي$") and msg.reply_to_message_id_ == 0 then
local function getpro(extra, result, success)
local user_msgs = database:get('user:msgs'..msg.chat_id_..':'..msg.sender_user_id_)
   if result.photos_[0] then
if is_sudo(msg) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Sudo'
else
t = 'مطور البوت'
end
elseif is_creator(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group creator'
else
t = 'منشئ الكروب'
end
elseif is_owner(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Owner'
else
t = 'مدير الكروب'
end
elseif is_mod(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Moderator'
else
t = 'ادمن للكروب'
end
elseif is_vip(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Moderator'
else
t = 'عضو مميز'
end
else
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Member'
else
t = 'عضو فقط'
end
end

if not database:get('bot:id:mute'..msg.chat_id_) then
  if not database:get('bot:id:photo'..msg.chat_id_) then
   if database:get('bot:lang:'..msg.chat_id_) then
sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_,"> Group ID : "..msg.chat_id_.."\n> Your ID : "..msg.sender_user_id_.."\n> UserName : "..get_info(msg.sender_user_id_).."\n> Your Rank : "..t.."\n> Msgs : "..user_msgs,msg.id_,msg.id_.."")
else
  sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_,"\n🎫┇ايديك ~⪼ ("..msg.sender_user_id_..")\n📜┇معرفك ~⪼ ( "..get_info(msg.sender_user_id_).." )\n📡┇موقعك ~⪼ "..t.."\n📨┇رسائلك ~⪼ {"..user_msgs.."}\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ",msg.id_,msg.id_.."")
   end
   else
if is_sudo(msg) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Sudo'
else
t = 'مطور البوت'
end
elseif is_creator(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group creator'
else
t = 'منشئ الكروب'
end
elseif is_owner(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Owner'
else
t = 'مدير الكروب'
end
elseif is_mod(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Moderator'
else
t = 'ادمن للكروب'
end
elseif is_vip(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Moderator'
else
t = 'عضو مميز'
end
else
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Member'
else
t = 'عضو فقط'
end
end
   if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "<b>> Group ID :</b> "..msg.chat_id_.."\n<b>> Your ID :</b> "..msg.sender_user_id_.."\n<b>> UserName :</b> "..get_info(msg.sender_user_id_).."\n<b>> Your Rank :</b> "..t.."\n<b>> Msgs : </b><code>"..user_msgs.."</code>", 1, 'html')
   else
send(msg.chat_id_, msg.id_, 1, "🎫┇ايديك ~⪼ ("..msg.sender_user_id_..")\n📜┇معرفك ~⪼ ( "..get_info(msg.sender_user_id_).." )\n📡┇موقعك ~⪼ "..t.."\n📨┇رسائلك ~⪼ <b>{"..user_msgs.."}</b>\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉", 1, 'html')
end
end
else
if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_ID_ *Disable!*', 1, 'md')
	else
   send(msg.chat_id_, msg.id_, 1, '☑️┇الايدي معطل',1, 'md')
end
end
   else
if is_sudo(msg) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Sudo'
else
t = 'مطور البوت'
end
elseif is_creator(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group creator'
else
t = 'منشئ الكروب'
end
elseif is_owner(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Owner'
else
t = 'مدير الكروب'
end
elseif is_mod(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Moderator'
else
t = 'ادمن للكروب'
end
elseif is_vip(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Moderator'
else
t = 'عضو مميز'
end
else
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Member'
else
t = 'عضو فقط'
end
end
   if not database:get('bot:id:mute'..msg.chat_id_) then
   if not database:get('bot:id:photo'..msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "You Have'nt Profile Photo!!\n\n> <b>> Group ID :</b> "..msg.chat_id_.."\n<b>> Your ID :</b> "..msg.sender_user_id_.."\n<b>> UserName :</b> "..get_info(msg.sender_user_id_).."\n<b>> Your Rank :</b> "..t.."\n<b>> Msgs : </b><code>"..user_msgs.."</code>", 1, 'html')
   else
send(msg.chat_id_, msg.id_, 1, "❕┇انت لا تملك صوره لحسابك\n🎫┇ايديك ~⪼ ("..msg.sender_user_id_..")\n📜┇معرفك ~⪼ ( "..get_info(msg.sender_user_id_).." )\n📡┇موقعك ~⪼ "..t.."\n📨┇رسائلك ~⪼ <b>{"..user_msgs.."}</b> \n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ", 1, 'html')
end
else
if is_sudo(msg) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Sudo'
else
t = 'مطور البوت'
end
elseif is_creator(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group creator'
else
t = 'منشئ الكروب'
end
elseif is_owner(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Owner'
else
t = 'مدير الكروب'
end
elseif is_mod(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Moderator'
else
t = 'ادمن للكروب'
end
elseif is_vip(msg.sender_user_id_, msg.chat_id_) then
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Moderator'
else
t = 'عضو مميز'
end
else
if database:get('bot:lang:'..msg.chat_id_) then
t = 'Group Member'
else
t = 'عضو فقط'
end
end
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, "<b>> Group ID :</b> "..msg.chat_id_.."\n<b>> Your ID :</b> "..msg.sender_user_id_.."\n<b>> UserName :</b> "..get_info(msg.sender_user_id_).."\n<b>> Your Rank :</b> "..t.."\n<b>> Msgs : </b><code>"..user_msgs.."</code>", 1, 'html')
   else
send(msg.chat_id_, msg.id_, 1, "🎫┇ايديك ~⪼ ("..msg.sender_user_id_..")\n📜┇معرفك ~⪼ ( "..get_info(msg.sender_user_id_).." )\n📡┇موقعك ~⪼ "..t.."\n📨┇رسائلك ~⪼ <b>{"..user_msgs.."}</b>\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉", 1, 'html')
end
end
else
if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_ID_ *Disable!*', 1, 'md')
	else
   send(msg.chat_id_, msg.id_, 1, '☑️┇الايدي معطل',1, 'md')
end
end
   end
   end
   tdcli_function ({
ID = "GetUserProfilePhotos",
user_id_ = msg.sender_user_id_,
offset_ = 0,
limit_ = 1
  }, getpro, nil)
end


   if text:match('^الحساب (%d+)$') then
  local id = text:match('^الحساب (%d+)$')
  local text = 'اضغط لمشاهده الحساب'
tdcli_function ({ID="SendMessage", chat_id_=msg.chat_id_, reply_to_message_id_=msg.id_, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_=text, disable_web_page_preview_=1, clear_draft_=0, entities_={[0] = {ID="MessageEntityMentionName", offset_=0, length_=19, user_id_=id}}}}, dl_cb, nil)
   end

   if text:match('^[Ww][Hh][Oo][Ii][Ss] (%d+)$') then
  local id = text:match('^[Ww][Hh][Oo][Ii][Ss] (%d+)$')
  local text = 'Click to view user!'
tdcli_function ({ID="SendMessage", chat_id_=msg.chat_id_, reply_to_message_id_=msg.id_, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_=text, disable_web_page_preview_=1, clear_draft_=0, entities_={[0] = {ID="MessageEntityMentionName", offset_=0, length_=19, user_id_=id}}}}, dl_cb, nil)
   end
local text = msg.content_.text_:gsub('معلومات','res')
if text:match("^[Rr][Ee][Ss] (.*)$") then
local memb = {string.match(text, "^([Rr][Ee][Ss]) (.*)$")}
function whois(extra,result,success)
if result.username_ then
 result.username_ = '@'..result.username_
   else
 result.username_ = 'لا يوجد معرف'
   end
  if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '> *Name* :'..result.first_name_..'\n> *Username* : '..result.username_..'\n> *ID* : '..msg.sender_user_id_, 1, 'md')
  else
send(msg.chat_id_, msg.id_, 1, '📜┇معرف ~⪼ ('..result.username_..')\n🔘┇الاسم ~⪼ ('..result.first_name_..')', 1, 'md')
  end
end
getUser(memb[2],whois)
end
   -----------------------------------------------------------------------------------------------
   if text == "enable pin" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Enable id" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تفعيل التثبيت" and is_owner(msg.sender_user_id_, msg.chat_id_) then
   if not database:get('bot:pin:mute'..msg.chat_id_) then
   if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '> *Pin is already enabled*️', 1, 'md')
 else
 send(msg.chat_id_, msg.id_, 1, '☑┇التثبيت بالفعل تم تفعيله', 1, 'md')
 end
   else
   if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '> *Pin has been enable*️', 1, 'md')
 else
 send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل التثبيت', 1, 'md')
  database:del('bot:pin:mute'..msg.chat_id_)
 end
 end
 end
   if text == "disable id" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "Disable id" and is_owner(msg.sender_user_id_, msg.chat_id_) or text == "تعطيل التثبيت" and is_owner(msg.sender_user_id_, msg.chat_id_) then
   if database:get('bot:pin:mute'..msg.chat_id_) then
   if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '> *Pin is already disabled*️', 1, 'md')
 else
 send(msg.chat_id_, msg.id_, 1, '☑┇التثبيت بالفعل تم تعطيله', 1, 'md')
 end
 else
   if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '> *Pin has been disable*️', 1, 'md')
 else
 send(msg.chat_id_, msg.id_, 1, '☑┇تم تعطيل التثبيت', 1, 'md')
   database:set('bot:pin:mute'..msg.chat_id_,true)
 end
 end
   end

   if text:match("^[Pp][Ii][Nn]$") and is_mod(msg.sender_user_id_, msg.chat_id_) and not is_owner(msg.sender_user_id_, msg.chat_id_) or text:match("^تثبيت$") and is_mod(msg.sender_user_id_, msg.chat_id_) and not is_owner(msg.sender_user_id_, msg.chat_id_) then
  local id = msg.id_
  local msgs = {[0] = id}
   if not database:get('bot:pin:mute'..msg.chat_id_) then
 pin(msg.chat_id_,msg.reply_to_message_id_,0)
	   database:set('pinnedmsg'..msg.chat_id_,msg.reply_to_message_id_)
if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_Msg han been_ *pinned!*', 1, 'md')
	else
   send(msg.chat_id_, msg.id_, 1, '☑┇تم تثبيت الرساله',1, 'md')
end
else
if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_Pin msg_ *Disable!*', 1, 'md')
	else
   send(msg.chat_id_, msg.id_, 1, '☑️┇التثبيت معطل',1, 'md')
end
end
end

   if text:match("^[Uu][Nn][Pp][Ii][Nn]$") and is_mod(msg.sender_user_id_, msg.chat_id_) and not is_owner(msg.sender_user_id_, msg.chat_id_) or text:match("^الغاء تثبيت$") and is_mod(msg.sender_user_id_, msg.chat_id_) and not is_owner(msg.sender_user_id_, msg.chat_id_) or text:match("^الغاء التثبيت") and is_mod(msg.sender_user_id_, msg.chat_id_) and not is_owner(msg.sender_user_id_, msg.chat_id_) then
   if not database:get('bot:pin:mute'..msg.chat_id_) then
   unpinmsg(msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_Pinned Msg han been_ *unpinned!*', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '☑┇تم الغاء تثبيت الرساله', 1, 'md')
end
else
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_UNPin msg_ *Disable!*', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '☑️┇الغاء التثبيت معطل', 1, 'md')
end
end
   end

   if text:match("^[Pp][Ii][Nn]$") and is_owner(msg.sender_user_id_, msg.chat_id_) or text:match("^تثبيت$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
  local id = msg.id_
  local msgs = {[0] = id}
 pin(msg.chat_id_,msg.reply_to_message_id_,0)
	   database:set('pinnedmsg'..msg.chat_id_,msg.reply_to_message_id_)
if database:get('bot:lang:'..msg.chat_id_) then
	send(msg.chat_id_, msg.id_, 1, '_Msg han been_ *pinned!*', 1, 'md')
	else
   send(msg.chat_id_, msg.id_, 1, '☑┇تم تثبيت الرساله',1, 'md')
end
end

   if text:match("^[Uu][Nn][Pp][Ii][Nn]$") and is_owner(msg.sender_user_id_, msg.chat_id_) or text:match("^الغاء تثبيت$") and is_owner(msg.sender_user_id_, msg.chat_id_) or text:match("^الغاء التثبيت") and is_owner(msg.sender_user_id_, msg.chat_id_) then
   unpinmsg(msg.chat_id_)
if database:get('bot:lang:'..msg.chat_id_) then
   send(msg.chat_id_, msg.id_, 1, '_Pinned Msg han been_ *unpinned!*', 1, 'md')
 else
   send(msg.chat_id_, msg.id_, 1, '☑┇تم الغاء تثبيت الرساله', 1, 'md')
end
   end

   if text:match("^[Vv][Ii][Ee][Ww]$") or text:match("^مشاهده منشور$") then
  database:set('bot:viewget'..msg.sender_user_id_,true)
if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '*Please send a post now!*', 1, 'md')
else
  send(msg.chat_id_, msg.id_, 1, '📥┇قم بارسال المنشور الان ',1, 'md')
end
   end
  end

   -----------------------------------------------------------------------------------------------
   if text:match("^[Hh][Ee][Ll][Pp]$") and is_mod(msg.sender_user_id_, msg.chat_id_) then

   local text =  [[
`هناك`  *6* `اوامر لعرضها`
*======================*
*h1* `لعرض اوامر الحمايه`
*======================*
*h2* `لعرض اوامر الحمايه بالتحذير`
*======================*
*h3* `لعرض اوامر الحمايه بالطرد`
*======================*
*h4* `لعرض اوامر الادمنيه`
*======================*
*h5* `لعرض اوامر المجموعه`
*======================*
*h6* `لعرض اوامر المطورين`
*======================*
]]
send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
   end

   if text:match("^[Hh]1$") and is_mod(msg.sender_user_id_, msg.chat_id_) then

   local text =  [[
*lock* `للقفل`
*unlock* `للفتح`
*======================*
*| links |* `الروابط`
*| tag |* `المعرف`
*| hashtag |* `التاك`
*| cmd |* `السلاش`
*| edit |* `التعديل`
*| webpage |* `الروابط الخارجيه`
*======================*
*| flood ban |* `التكرار بالطرد`
*| flood mute |* `التكرار بالكتم`
*| flood del |* `التكرار بالمسح`
*| unlock flood all |* `جميع التكرار`
*| gif |* `الصور المتحركه`
*| photo |* `الصور`
*| sticker |* `الملصقات`
*| video |* `الفيديو`
*| inline |* `لستات شفافه`
*======================*
*| text |* `الدردشه`
*| fwd |* `التوجيه`
*| music |* `الاغاني`
*| video note |* `بصمه الفيديو`
*| voice |* `الصوت`
*| contact |* `جهات الاتصال`
*| service |* `اشعارات الدخول`
*| markdown |* `الماركدون`
*| file |* `الملفات`
*======================*
*| location |* `المواقع`
*| bots |* `البوتات`
*| bots ban |* `البوتات بطرد العضو`
*| spam |* `الكلايش`
*| arabic |* `العربيه`
*| english |* `الانكليزيه`
*| media |* `كل الميديا`
*| all |* `مع العدد قفل الميديا بالثواني`
*======================*
]]
send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
   end

   if text:match("^[Hh]2$") and is_mod(msg.sender_user_id_, msg.chat_id_) then

   local text =  [[
*lock* `للقفل`
*unlock* `للفتح`
*======================*
*| links warn |* `الروابط`
*| tag warn |* `المعرف`
*| hashtag warn |* `التاك`
*| cmd warn |* `السلاش`
*| webpage warn |* `الروابط الخارجيه`
*======================*
*| gif warn |* `الصور المتحركه`
*| photo warn |* `الصور`
*| sticker warn |* `الملصقات`
*| video warn |* `الفيديو`
*| inline warn |* `لستات شفافه`
*======================*
*| text warn |* `الدردشه`
*| fwd warn |* `التوجيه`
*| music warn |* `الاغاني`
*| video note warn |* `بصمه الفيديو`
*| voice warn |* `الصوت`
*| contact warn |* `جهات الاتصال`
*| markdown warn |* `الماركدون`
*| file warn |* `الملفات`
*======================*
*| location warn |* `المواقع`
*| spam |* `الكلايش`
*| arabic warn |* `العربيه`
*| english warn |* `الانكليزيه`
*| media warn |* `كل الميديا`
*======================*
]]
send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
   end

   if text:match("^[Hh]3$") and is_mod(msg.sender_user_id_, msg.chat_id_) then

   local text =  [[
*lock* `للقفل`
*unlock* `للفتح`
*======================*
*| links ban |* `الروابط`
*| tag ban |* `المعرف`
*| hashtag ban |* `التاك`
*| cmd ban |* `السلاش`
*| webpage ban |* `الروابط الخارجيه`
*======================*
*| gif ban |* `الصور المتحركه`
*| photo ban |* `الصور`
*| sticker ban |* `الملصقات`
*| video ban |* `الفيديو`
*| inline ban |* `لستات شفافه`
*| markdown ban |* `الماركدون`
*| file ban |* `الملفات`
*======================*
*| text ban |* `الدردشه`
*| fwd ban |* `التوجيه`
*| music ban |* `الاغاني`
*| video note ban |* `بصمه الفيديو`
*| voice ban |* `الصوت`
*| contact ban |* `جهات الاتصال`
*| location ban |* `المواقع`
*======================*
*| arabic ban |* `العربيه`
*| english ban |* `الانكليزيه`
*| media ban |* `كل الميديا`
*======================*
]]
send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
   end

   if text:match("^[Hh]4$") and is_mod(msg.sender_user_id_, msg.chat_id_) then

   local text =  [[
*======================*
*| admin group |* `اظهار ادمنيه المجموعه`
*| setmote admins |* `رفع الادمنيه`
*| setmote |* `رفع ادمن`
*| remmote |* `ازاله ادمن`
*| setvip |* `رفع عضو مميز`
*| remvip |* `ازاله عضو مميز`
*| setlang en |* `تغير اللغه للانكليزيه`
*| setlang ar |* `تغير اللغه للعربيه`
*| unsilent |* `لالغاء كتم العضو`
*| silent |* `لكتم عضو`
*| ban |* `حظر عضو`
*| unban |* `الغاء حظر العضو`
*| kick |* `طرد عضو`
*| id |* `لاظهار الايدي [بالرد] `
*| pin |* `تثبيت رساله!`
*| unpin |* `الغاء تثبيت الرساله!`
*| res |* `معلومات حساب بالايدي`
*| whois |* `مع الايدي لعرض صاحب الايدي`
*| disable pin |* `تعطيل تثبيت رساله!`
*| enable pin |* `تفعيل تثبيت رساله!`
*======================*
*| s del |* `اظهار اعدادات المسح`
*| s warn |* `اظهار اعدادات التحذير`
*| s ban |* `اظهار اعدادات الطرد`
*| silentlist |* `اظهار المكتومين`
*| banlist |* `اظهار المحظورين`
*| modlist |* `اظهار الادمنيه`
*| viplist |* `اظهار الاعضاء المميزين`
*| del |* `حذف رساله بالرد`
*| link |* `اظهار الرابط`
*| rules |* `اظهار القوانين`
*| bots |* `اظهار البوتات`
*======================*
*| bad |* `منع كلمه`
*| unbad |* `الغاء منع كلمه`
*| badlist |* `اظهار الكلمات الممنوعه`
*| stats |* `لمعرفه ايام البوت`
*| del wlc |* `حذف الترحيب`
*| set wlc |* `وضع الترحيب`
*| wlc on |* `تفعيل الترحيب`
*| wlc off |* `تعطيل الترحيب`
*| get wlc |* `معرفه الترحيب الحالي`
*| add rep |* `اضافه رد`
*| rem rep |* `حذف رد`
*| add blocklist |* `اضافه محظورين المجموعه`
*| rep owner list |* `اظهار ردود المدير`
*| clean rep owner |* `مسح ردود المدير`
*| disable reply bot |* `تعطيل ردود البوت`
*| disable reply sudo |* `تعطيل ردود المطور`
*| disable reply owner |* `تعطيل ردود المدير`
*| disable id |* `تعطيل الايدي`
*| disable id photo |* `تعطيل الايدي بالصوره`
*| enable reply bot |* `تفعيل ردود البوت`
*| enable reply sudo |* `تفعيل ردود المطور`
*| enable reply owner |* `تفعيل ردود المدير`
*| enable id |* `تفعيل الايدي`
*| enable id photo |* `تفعيل الايدي بالصوره`
*======================*
]]
send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
   end

   if text:match("^[Hh]5$") and is_mod(msg.sender_user_id_, msg.chat_id_) then

   local text =  [[
*======================*
*clean* `مع الاوامر ادناه بوضع فراغ`

*| banlist |* `المحظورين`
*| badlist |* `كلمات المحظوره`
*| modlist |* `الادمنيه`
*| viplist |* `الاعضاء المميزين`
*| link |* `الرابط المحفوظ`
*| silentlist |* `المكتومين`
*| bots |* `بوتات تفليش وغيرها`
*| rules |* `القوانين`
*| deactive |* `طرد المتروكين`
*| delete |* `طرد المحذوفين`
*| blocklist |* `محظورين المجموعه`
*======================*
*set* `مع الاوامر ادناه بدون فراغ`

*| link |* `لوضع رابط`
*| rules |* `لوضع قوانين`
*| name |* `مع الاسم لوضع اسم`
*| photo |* `لوضع صوره`
*| about |* `لوضع وصف`

*======================*

*| flood ban |* `وضع تكرار بالطرد`
*| flood mute |* `وضع تكرار بالكتم`
*| flood del |* `وضع تكرار بالكتم`
*| flood time |* `لوضع زمن تكرار بالطرد او الكتم`
*| spam del |* `وضع عدد السبام بالمسح`
*| spam warn |* `وضع عدد السبام بالتحذير`
*======================*
]]
send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
   end

   if text:match("^[Hh]6$") and is_sudo(msg) then

   local text =  [[
*======================*
*| add |* `تفعيل البوت`
*| rem |* `تعطيل البوت`
*| setexpire |* `وضع ايام للبوت`
*| stats gp |* `لمعرفه ايام البوت`
*| plan1 + id |* `تفعيل البوت 30 يوم`
*| plan2 + id |* `تفعيل البوت 90 يوم`
*| plan3 + id |* `تفعيل البوت لا نهائي`
*| join + id |* `لاضافتك للكروب`
*| leave + id |* `لخروج البوت`
*| leave |* `لخروج البوت`
*| disable leave |* `تعطيل خروج البوت`
*| enable leave |* `تفعيل خروج البوت`
*| stats gp + id |* `لمعرفه  ايام البوت`
*| view |* `لاظهار مشاهدات منشور`
*| update source |* `لتحديث البوت`
*| clean gbanlist |* `لحذف الحظر العام`
*| clean gsilentlist |* `لحذف الحظر العام`
*| clean owners |* `لحذف قائمه المدراء`
*| clean creator |* `لحذف قائمه المنشئين`
*| adminlist |* `لاظهار ادمنيه البوت`
*| gbanlist |* `لاظهار المحظورين عام `
*| gsilentlist |* `لاظهار المحظورين عام `
*| ownerlist |* `لاظهار مدراء البوت`
*| creatorlist |* `لاظهار مدراء البوت`
*| setadmin |* `لاضافه ادمن`
*| remadmin |* `لحذف ادمن`
*| setowner |* `لاضافه مدير`
*| remowner |* `لحذف مدير`
*| set creator |* `لاضافه منشئ`
*| rem creator |* `لحذف منشئ`
*| banall |* `لحظر العام`
*| unbanall |* `لالغاء العام`
*| silentall |* `لحظر العام`
*| unsilentall |* `لالغاء العام`
*| invite |* `لاضافه عضو`
*| groups |* `عدد كروبات البوت`
*| bc |* `لنشر شي للمطورين`
*| send |* `لنشر شي للمطور الاساسي`
*| disable bc |* `تعطيل الاذاعه`
*| enable bc |* `تفعيل الاذاعه`
*| add sudo |* `اضف مطور`
*| rem sudo |* `حذف مطور`
*| add rep all |* `اضف رد لكل المجموعات`
*| rem rep all |* `حذف رد لكل المجموعات`
*| change ph |* `تغير جهه المطور`
*| change dev text |* `تغير امر المطور بالكليشه`
*| del dev text |* `لحذف كليشه المطور`
*| sudo list |* `اظهار المطورين`
*| rep sudo list |* `اظهار ردود المطور`
*| clean sudo |* `مسح المطورين`
*| clean rep sudo |* `مسح ردود المطور`
*======================*
]]
send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
   end

if text == 'استعاده الاوامر' and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
redis:del('help'..bot_id, text)
redis:del('h1'..bot_id, text)
redis:del('h2'..bot_id, text)
redis:del('h3'..bot_id, text)
redis:del('h4'..bot_id, text)
redis:del('h5'..bot_id, text)
redis:del('h6'..bot_id, text)
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '<b>Deleted</b>', 1, 'html')
else
 send(msg.chat_id_, msg.id_, 1, '☑️┇تم استعاده جميع كلايش الاوامر', 1, 'html')
  end
  end

if text == 'تغير امر الاوامر' and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '<code» send the</code> <b>help</b>', 1, 'html')
else
send(msg.chat_id_, msg.id_, 1, '📥┇الان يمكنك ارسال الكليشه  ليتم حفظها', 1, 'html')
end
redis:set('hhh'..msg.sender_user_id_..''..bot_id, 'msg')
  return false end
if text:match("^(.*)$") then
local keko2 = redis:get('hhh'..msg.sender_user_id_..''..bot_id)
if keko2 == 'msg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '<code» Saved Send a</code> <b>help to watch the changes</b>', 1, 'html')
else
send(msg.chat_id_, msg.id_, 1, '☑️┇تم حفظ الكليشه يمكنك اظهارها بارسال الامر', 1, 'html')
end
redis:set('hhh'..msg.sender_user_id_..''..bot_id, 'no')
redis:set('help'..bot_id, text)
send(msg.chat_id_, msg.id_, 1, text , 1, 'html')
  return false end
 end

   if text:match("^الاوامر$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
local help = redis:get('help'..bot_id)
   local text =  [[
📮┇هناكـ {6} اوامر لعرضها
 ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🗑┇م1 ~> لعرض اوامر الحمايه

🚫┇م2 ~> لعرض اوامر الحمايه بالتحذير

🚷┇م3 ~> لعرض اوامر الحمايه بالطرد

🥈┇م5 ~> لعرض اوامر الادمنيه

🥇┇م4 ~> لعرض اوامر المدراء

🎖┇م6 ~> لعرض اوامر المطورين
 ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
]]
send(msg.chat_id_, msg.id_, 1, (help or text), 1, 'md')
   end

if text == 'تغير امر م1' and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '<code» send the</code> <b>help</b>', 1, 'html')
else
send(msg.chat_id_, msg.id_, 1, '📥┇الان يمكنك ارسال الكليشه  ليتم حفظها', 1, 'html')
end
redis:set('h11'..msg.sender_user_id_..''..bot_id, 'msg')
  return false end
if text:match("^(.*)$") then
local keko2 = redis:get('h11'..msg.sender_user_id_..''..bot_id)
if keko2 == 'msg' then
if database:get('bot:lang:'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '<code» Saved Send a</code> <b>help to watch the changes</b>', 1, 'html')
else
send(msg.chat_id_, msg.id_, 1, '☑️┇تم حفظ الكليشه يمكنك اظهارها بارسال الامر', 1, 'html')
end
redis:set('h11'..msg.sender_user_id_..''..bot_id, 'no')
redis:set('h1'..bot_id, text)
send(msg.chat_id_, msg.id_, 1, text , 1, 'html')
  return false end
 end
   if text:match("^م1$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
local h1 = redis:get('h1'..bot_id)
   local text =  [[
📮┇ اوامر حمايه  الجمعوعه بالمسح
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🔒┇قفل ~⪼ لقفل امر
🔓┇فتح ~⪼ لفتح امر
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🔐┇الروابط
🔐┇المعرف
🔐┇التاك
🔐┇الشارحه
🔐┇التعديل
🔐┇التثبيت
🔐┇المواقع
🔐┇المتحركه
🔐┇الملفات
🔐┇الصور

🔐┇الملصقات
🔐┇الفيديو
🔐┇الانلاين
🔐┇الدردشه
🔐┇التوجيه
🔐┇الاغاني
🔐┇الصوت
🔐┇الجهات
🔐┇الماركدون
🔐┇الاشعارات

🔐┇الشبكات
🔐┇البوتات
🔐┇الكلايش
🔐┇العربيه
🔐┇الانكليزية
🔐┇الوسائط
🔐┇التكرار بالطرد
🔐┇التكرار بالكتـم
🔐┇التكرار بالمسح
🔐┇الكل بالثواني + العدد
🔐┇الكل بالساعه + العدد
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
]]
send(msg.chat_id_, msg.id_, 1, (h1 or text), 1, 'md')
   end

if text == 'تغير امر م2' and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
 if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '<code» send the</code> <b>help</b>', 1, 'html')
 else
 send(msg.chat_id_, msg.id_, 1, '📥┇الان يمكنك ارسال الكليشه  ليتم حفظها', 1, 'html')
 end
 redis:set('h22'..msg.sender_user_id_..''..bot_id, 'msg')
   return false end
 if text:match("^(.*)$") then
 local keko2 = redis:get('h22'..msg.sender_user_id_..''..bot_id)
 if keko2 == 'msg' then
 if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '<code» Saved Send a</code> <b>help to watch the changes</b>', 1, 'html')
 else
 send(msg.chat_id_, msg.id_, 1, '☑️┇تم حفظ الكليشه يمكنك اظهارها بارسال الامر', 1, 'html')
 end
 redis:set('h22'..msg.sender_user_id_..''..bot_id, 'no')
 redis:set('h2'..bot_id, text)
 send(msg.chat_id_, msg.id_, 1, text , 1, 'html')
   return false end
  end
   if text:match("^م2$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
 local h2 = redis:get('h2'..bot_id)
   local text =  [[
📮┇  اوامر حمايه المجموعه بالتحذير
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🔒┇قفل ~⪼ لقفل امر
🔓┇فتح ~⪼ لفتح امر
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🔐┇ الروابط بالتحذير
🔐┇ المعرف بالتحذير
🔐┇ التاك بالتحذير
🔐┇ الماركدون بالتحذير
🔐┇ الشارحه بالتحذير
🔐┇ المواقع بالتحذير
🔐┇ التثبيت بالتحذير
🔐┇ المتحركه بالتحذير

🔐┇ الصور بالتحذير
🔐┇ الملصقات بالتحذير
🔐┇ الفيديو بالتحذير
🔐┇ الانلاين بالتحذير
🔐┇ الدردشه بالتحذير
🔐┇ الملفات بالتحذير
🔐┇ التوجيه بالتحذير

🔐┇ الاغاني بالتحذير
🔐┇ الصوت بالتحذير
🔐┇ الجهات بالتحذير
🔐┇ الشبكات بالتحذير
🔐┇ الكلايش بالتحذير
🔐┇ العربيه بالتحذير
🔐┇ الانكليزيه بالتحذير
🔐┇ الكل بالتحذير
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
]]
send(msg.chat_id_, msg.id_, 1, (h2 or text), 1, 'md')
   end
if text == 'تغير امر م3' and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
 if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '<code» send the</code> <b>help</b>', 1, 'html')
 else
 send(msg.chat_id_, msg.id_, 1, '📥┇الان يمكنك ارسال الكليشه  ليتم حفظها', 1, 'html')
 end
 redis:set('h33'..msg.sender_user_id_..''..bot_id, 'msg')
   return false end
 if text:match("^(.*)$") then
 local keko2 = redis:get('h33'..msg.sender_user_id_..''..bot_id)
 if keko2 == 'msg' then
 if database:get('bot:lang:'..msg.chat_id_) then
 send(msg.chat_id_, msg.id_, 1, '<code» Saved Send a</code> <b>help to watch the changes</b>', 1, 'html')
 else
 send(msg.chat_id_, msg.id_, 1, '☑️┇تم حفظ الكليشه يمكنك اظهارها بارسال الامر', 1, 'html')
 end
 redis:set('h33'..msg.sender_user_id_..''..bot_id, 'no')
 redis:set('h3'..bot_id, text)
 send(msg.chat_id_, msg.id_, 1, text , 1, 'html')
   return false end
  end
   if text:match("^م3$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
local h3 = redis:get('h3'..bot_id)
   local text =  [[
📮┇اوامر الحمايه  المجموعه بالطرد
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🔒┇قفل ~⪼ لقفل امر
🔓┇فتح ~⪼ لفتح امر
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🔐┇الروابط بالطرد
🔐┇المعرف بالطرد
🔐┇التاك بالطرد
🔐┇الشارحه بالطرد
🔐┇المواقع بالطرد
🔐┇الماركدون بالطرد
🔐┇المتحركه بالطرد
🔐┇لملفات بالطرد
🔐┇الصور بالطرد
🔐┇لملصقات بالطرد
🔐┇الفيديو بالطرد

🔐┇الانلاين بالطرد
🔐┇الدردشه بالطرد
🔐┇التوجيه بالطرد
🔐┇الاغاني بالطرد
🔐┇الصوت بالطرد
🔐┇الجهات بالطرد
🔐┇الشبكات بالطرد
🔐┇الكلايش بالطرد
🔐┇العربيه بالطرد
🔐┇الانكليزيه بالطرد
🔐┇الكل بالطرد
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
]]
send(msg.chat_id_, msg.id_, 1, (h3 or text), 1, 'md')
   end
if text == 'تغير امر م4' and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
  if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '<code» send the</code> <b>help</b>', 1, 'html')
  else
  send(msg.chat_id_, msg.id_, 1, '📥┇الان يمكنك ارسال الكليشه  ليتم حفظها', 1, 'html')
  end
  redis:set('h44'..msg.sender_user_id_..''..bot_id, 'msg')
return false end
  if text:match("^(.*)$") then
  local keko2 = redis:get('h44'..msg.sender_user_id_..''..bot_id)
  if keko2 == 'msg' then
  if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '<code» Saved Send a</code> <b>help to watch the changes</b>', 1, 'html')
  else
  send(msg.chat_id_, msg.id_, 1, '☑️┇تم حفظ الكليشه يمكنك اظهارها بارسال الامر', 1, 'html')
  end
  redis:set('h44'..msg.sender_user_id_..''..bot_id, 'no')
  redis:set('h4'..bot_id, text)
  send(msg.chat_id_, msg.id_, 1, text , 1, 'html')
return false end
   end
   if text:match("^م4$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
local h4 = redis:get('h4'..bot_id)
local text =  [[
🥈┇اوامر الادمنيه
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🚫┇كتم
🚫┇حظر
🚫┇طرد
🚫┇الغاء تثبيت
🚹┇الغاء حظر
🚹┇الغاء كتم
🚹┇تثبيت
🗑┇اعدادات المسح
📛┇اعدادات التحذير
🚫┇اعدادات الطرد

🔇┇المكتومين
🚫┇المحظورين
📵┇قائمه المنع
📮┇الرابط
📝┇القوانين
📵┇منع + الكلمه
🚹┇الغاء منع + الكلمه
🕕┇الوقت
🗑┇حذف الترحيب
📜┇وضع ترحيب
🛅┇تفعيل الترحيب
🚫┇تعطيل الترحيب
🗒┇جلب الترحيب

📝┇معلومات + ايدي
📝┇الحساب + ايدي
📯┇كرر + الكلمه
🤖┇كشف البوتات
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🔘┇وضع + الاوامر الادناه
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
📝┇رابط
📝┇اسم
📝┇صوره
📝┇وصف
📝┇قوانين
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🗑┇مسح + الاوامر الادناه
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🚫┇المحظورين
🔇┇قائمه المنع
📮┇الرابط
🔇┇المكتومين
🤖┇البوتات
📝┇القوانين
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
]]
send(msg.chat_id_, msg.id_, 1, (h4 or text), 1, 'html')
   end
if text == 'تغير امر م5' and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
  if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '<code» send the</code> <b>help</b>', 1, 'html')
  else
  send(msg.chat_id_, msg.id_, 1, '📥┇الان يمكنك ارسال الكليشه  ليتم حفظها', 1, 'html')
  end
  redis:set('h55'..msg.sender_user_id_..''..bot_id, 'msg')
return false end
  if text:match("^(.*)$") then
  local keko2 = redis:get('h55'..msg.sender_user_id_..''..bot_id)
  if keko2 == 'msg' then
  if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '<code» Saved Send a</code> <b>help to watch the changes</b>', 1, 'html')
  else
  send(msg.chat_id_, msg.id_, 1, '☑️┇تم حفظ الكليشه يمكنك اظهارها بارسال الامر', 1, 'html')
  end
  redis:set('h55'..msg.sender_user_id_..''..bot_id, 'no')
  redis:set('h5'..bot_id, text)
  send(msg.chat_id_, msg.id_, 1, text , 1, 'html')
return false end
   end
   if text:match("^م5$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
local h5 = redis:get('h5'..bot_id)
   local text =  [[
🥇┇ اوامر المدراء
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🔘┇وضع :- مع الاوامر ادناه
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
📝┇تكرار بالطرد + العدد
📝┇تكرار بالكتم + العدد
📝┇تكرار بالمسح + العدد
📝┇زمن التكرار + العدد
📝┇كلايش بالمسح + العدد
📝┇كلايش بالتحذير + العدد
🔼┇رفع ادمن
🔽┇تنزيل ادمن
🔼┇رفع عضو مميز
🔽┇تنزيل عضو مميز

✔️┇تفعيل الايدي بالصوره
✖️┇تعطيل الايدي بالصوره
✔️┇تفعيل الايدي
✖️┇تعطيل الايدي
✔️┇تفعيل ردود البوت
✖️┇تعطيل ردود البوت
✔️┇تفعيل ردود المطور
✖️┇تعطيل ردود المطور
✔️┇تفعيل ردود المدير
✖️┇تعطيل ردود المدير
✔️┇تفعيل التثبيت
✖️┇تعطيل التثبيت
✔️┇تنظيف + عدد

🖇┇اضف رد
🖇┇ردود المدير
🖇┇ادمنيه المجموعه
🖇┇رفع الادمنيه
🖇┇الادمنيه
🖇┇الاعضاء المميزين

🗑┇مسح الادمنيه
🗑┇مسح الاعضاء المميزين
🗑┇مسح ردود المدير
🗑┇حذف رد
🗑┇تنظيف قائمه المحظورين
🗑┇مسح الادمنيه
🗑┇مسح الاعضاء المميزين
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🏅┇اوامر المنشئين
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🔼┇رفع مدير
🔽┇تنزيل مدير
🚫┇طرد المحذوفين
🚫┇طرد المتروكين
🖇┇المدراء
🗑┇مسح المدراء
🗑┇تنظيف قائمه المحظورين
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
]]
send(msg.chat_id_, msg.id_, 1, (h5 or text), 1, 'html')
   end
if text == 'تغير امر م6' and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then
  if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '<code» send the</code> <b>help</b>', 1, 'html')
  else
  send(msg.chat_id_, msg.id_, 1, '📥┇الان يمكنك ارسال الكليشه  ليتم حفظها', 1, 'html')
  end
  redis:set('h66'..msg.sender_user_id_..''..bot_id, 'msg')
return false end
  if text:match("^(.*)$") then
  local keko2 = redis:get('h66'..msg.sender_user_id_..''..bot_id)
  if keko2 == 'msg' then
  if database:get('bot:lang:'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '<code» Saved Send a</code> <b>help to watch the changes</b>', 1, 'html')
  else
  send(msg.chat_id_, msg.id_, 1, '☑️┇تم حفظ الكليشه يمكنك اظهارها بارسال الامر', 1, 'html')
  end
  redis:set('h66'..msg.sender_user_id_..''..bot_id, 'no')
  redis:set('h6'..bot_id, text)
  send(msg.chat_id_, msg.id_, 1, text , 1, 'html')
return false end
   end
   if text:match("^م6$") and is_sudo(msg) then
local h6 = redis:get('h6'..bot_id)
   local text =  [[
🎖┇اوامر المطور
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
✔️┇تفعيل
✖️┇تعطيل
✔️┇تفعيل المغادره
✖️┇تعطيل المغادره
✔️┇تفعيل الاذاعه
✖️┇تعطيل الاذاعه
🚷┇مغادره + id
🚷┇مغادره

🔘┇وضع وقت + عدد
🔘┇المده1 + id
🔘┇المده2 + id
🔘┇المده3 + id
🔘┇اضافه + id
🔘┇وقت المجموعه + id
🔘┇ردود المطور
🔘┇تغير امر المطور
🔘┇تغير امر المطور بالكليشه
🔘┇مسح امر المطور بالكليشه
🔘┇اضف رد للكل
🔘┇تحديث

📜┇قائمه العام
📜┇المكتومين عام
🥇┇المدراء
🏅┇المنشئين
🔼┇رفع مدير
🔽┇تنزيل مدير
🔼┇رفع منشئ
🔽┇تنزيل منشئ
🚫┇حظر عام
⭕️┇الغاء العام

🚫┇كتم عام
⭕️┇الغاء كتم العام
🔘┇الكروبات
📣┇اذاعه + كليشه
📣┇ارسال + كليشه (للاساسي)
🛄┇اضف مطور
🚷┇حذف مطور
📜┇المطورين
👁‍🗨┇مشاهده منشور

🗑┇حذف رد للكل
🗑┇استعاده الاوامر
🗑┇مسح ردود المطور
🗑┇مسح المطورين
🗑┇مسح قائمه العام
🗑┇مسح المدراء
🗑┇مسح المنشئين
🗑┇مسح المكتومين عام

🏷┇تغير امر الاوامر
🏷┇تغير امر م1
🏷┇تغير امر م2
🏷┇تغير امر م3
🏷┇تغير امر م4
🏷┇تغير امر م5
🏷┇تغير امر م6
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
]]
send(msg.chat_id_, msg.id_, 1, (h6 or text), 1, 'html')
   end

if text:match("^source$") or text:match("^اصدار$") or text:match("^الاصدار$") or text:match("^السورس$") or text:match("^سورس$") then

   local text =  [[
👋┇اهلا بك في سورس تشاكي 🦁ֆ

🌐┇<strong>TshAkE TEAM</strong>

◀┇<a href="https://telegram.me/TshAkETEAM">قناه السورس، 🦁" </a>
◀┇<a href="https://telegram.me/TshAkE_DEV">قناه شروحات سورس، 🦁" </a>

🔎┇<a href="https://github.com/moodlIMyIl/TshAkE">رابط Github Cli (الرقم)،⚜️ </a>

🔎┇<a href="https://github.com/moodlIMyIl/TshAkEapi">رابط Github Api (التوكن)،⚜️ </a>

]]
send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
   end

if text:match("^اريد رابط حذف$") or text:match("^رابط حذف$") or text:match("^رابط الحذف$") or text:match("^الرابط حذف$") or text:match("^اريد رابط الحذف$") then

   local text =  [[
🗑┇رابط حذف التلي ، ⬇️
‼️┇احذف ولا ترجع عيش حياتك'
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
🔎┇<a href="https://telegram.org/deactivate">اضغط هنا للحذف الحساب" </a>
]]
send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
   end
  -----------------------------------------------------------------------------------------------
 end
  -----------------------------------------------------------------------------------------------
 -- end code --
  -----------------------------------------------------------------------------------------------
  elseif (data.ID == "UpdateChat") then
chat = data.chat_
chats[chat.id_] = chat
  -----------------------------------------------------------------------------------------------
  elseif (data.ID == "UpdateMessageEdited") then
   local msg = data
  -- vardump(msg)
  	function get_msg_contact(extra, result, success)
	local text = (result.content_.text_ or result.content_.caption_)
--vardump(result)
	if result.id_ and result.content_.text_ then
	database:set('bot:editid'..result.id_,result.content_.text_)
	end
  if not is_mod(result.sender_user_id_, result.chat_id_) then
   check_filter_words(result, text)
   if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or
text:match("[Tt].[Mm][Ee]") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or
text:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") then
   if database:get('bot:links:mute'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
	end

   if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or
text:match("[Tt].[Mm][Ee]") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or
text:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") then
   if database:get('bot:links:warn'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
send(msg.chat_id_, 0, 1, "🚫┇ممنوع عمل تعديل للروابط", 1, 'html')
	end
end
end

	if result.id_ and result.content_.text_ then
	database:set('bot:editid'..result.id_,result.content_.text_)
  if not is_mod(result.sender_user_id_, result.chat_id_) then
   check_filter_words(result, text)
   	if text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://") or text:match(".[Ii][Rr]") or text:match(".[Cc][Oo][Mm]") or text:match(".[Oo][Rr][Gg]") or text:match(".[Ii][Nn][Ff][Oo]") or text:match("[Ww][Ww][Ww].") or text:match(".[Tt][Kk]") then
   if database:get('bot:webpage:mute'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
	end

   if database:get('bot:webpage:warn'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
send(msg.chat_id_, 0, 1, "🚫┇ممنوع عمل تعديل للمواقع", 1, 'html')
	end
end
end
end
end
	if result.id_ and result.content_.text_ then
	database:set('bot:editid'..result.id_,result.content_.text_)
  if not is_mod(result.sender_user_id_, result.chat_id_) then
   check_filter_words(result, text)
   if text:match("@") then
   if database:get('bot:tag:mute'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
	end
	   if database:get('bot:tag:warn'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
send(msg.chat_id_, 0, 1,  "🚫┇ممنوع عمل تعديل للمعرفات", 1, 'html')

	end
end
end
	if result.id_ and result.content_.text_ then
	database:set('bot:editid'..result.id_,result.content_.text_)
  if not is_mod(result.sender_user_id_, result.chat_id_) then
   check_filter_words(result, text)
   	if text:match("#") then
   if database:get('bot:hashtag:mute'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
	end
	   if database:get('bot:hashtag:warn'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
send(msg.chat_id_, 0, 1, "🚫┇ممنوع عمل تعديل للتاكات", 1, 'html')
	end
end
end
	if result.id_ and result.content_.text_ then
	database:set('bot:editid'..result.id_,result.content_.text_)
  if not is_mod(result.sender_user_id_, result.chat_id_) then
   check_filter_words(result, text)
   	if text:match("/")  then
   if database:get('bot:cmd:mute'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
	end
	   if database:get('bot:cmd:warn'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
send(msg.chat_id_, 0, 1, "🚫┇ممنوع عمل تعديل للشارحه", 1, 'html')
	end
end
end
end
	if result.id_ and result.content_.text_ then
	database:set('bot:editid'..result.id_,result.content_.text_)
  if not is_mod(result.sender_user_id_, result.chat_id_) then
   check_filter_words(result, text)
   	if text:match("[\216-\219][\128-\191]") then
   if database:get('bot:arabic:mute'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
	end
	end
	   if database:get('bot:arabic:warn'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
send(msg.chat_id_, 0, 1, "🚫┇ممنوع عمل تعديل  للغه العربيه", 1, 'html')
	end
 end
end
end
	if result.id_ and result.content_.text_ then
	database:set('bot:editid'..result.id_,result.content_.text_)
  if not is_mod(result.sender_user_id_, result.chat_id_) then
   check_filter_words(result, text)
   if text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
   if database:get('bot:english:mute'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
	end
	   if database:get('bot:english:warn'..result.chat_id_) then
local msgs = {[0] = data.message_id_}
 delete_msg(msg.chat_id_,msgs)
send(msg.chat_id_, 0, 1, "🚫┇ممنوع عمل تعديل  للغه الانكليزيه", 1, 'html')
end
end
end
end
	if result.id_ and result.content_.text_ then
	database:set('bot:editid'..result.id_,result.content_.text_)
  if not is_mod(result.sender_user_id_, result.chat_id_) then
   check_filter_words(result, text)
	if database:get('editmsg'..msg.chat_id_) == 'delmsg' then
  local id = msg.message_id_
  local msgs = {[0] = id}
  local chat = msg.chat_id_
  delete_msg(chat,msgs)
  send(msg.chat_id_, 0, 1, "🚫┇ممنوع التعديل هنا", 1, 'html')
	elseif database:get('editmsg'..msg.chat_id_) == 'didam' then
	if database:get('bot:editid'..msg.message_id_) then
		local old_text = database:get('bot:editid'..msg.message_id_)
send(msg.chat_id_, msg.message_id_, 1, '🚫┇لقد قمت بالتعديل\n\n✉┇رسالتك السابقه \n\n• {'..old_text..'}', 1, 'md')
	end
end
end
end
end
	end

getMessage(msg.chat_id_, msg.message_id_,get_msg_contact)
  -----------------------------------------------------------------------------------------------
  elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
tdcli_function ({ID="GetChats", offset_order_="9223372036854775807", offset_chat_id_=0, limit_=20}, dl_cb, nil)
  end
  -----------------------------------------------------------------------------------------------
end

--[[                                    
   _____    _        _    _    _____    
  |_   _|__| |__    / \  | | _| ____|   
    | |/ __| '_ \  / _ \ | |/ /  _|     
    | |\__ \ | | |/ ___ \|   <| |___   
    |_||___/_| |_/_/   \_\_|\_\_____|   
              CH > @TshAkETEAM
--]]
