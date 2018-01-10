sudos = dofile('sudo.lua')
os.execute('./tg -s ./TSHAKE.lua $@ --bot='..token)
