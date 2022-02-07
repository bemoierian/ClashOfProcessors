<h1 align="center">
   🔱 Clash of Processors 🔱
</h1> 
<h4 align="center">
    An x86 Assembly project
</h4>
<div>
<img src="/gameplay.png" title="Gameplay">
</div>
<h2>
    Description
</h2>
In this project, we made an assembler in the form of a 2 player game.
Each player has his own 8086 processor and 16-bit memory (RAM), your target is store the value "105e" in one of your opponent's registers.
In each round you are able to write a complete x86 assembly instruction that will be executed on your opponent's processor but be careful, your opponent has set a forbidden character that you can't use in your instruction, in addition to some power ups that may be used against you, which makes it harder to reach your target.
Additional features: Full chatting mode, in-game chat (in 2 Players using serial port version), 2 levels, flying objects and a gun to shoot them and earn additional points.
<h2>
    How To Run
</h2>
Copy the project content into the path of your DosBox. <br>
To run 2 players on 1 PC:
<ul>
    <li>Open DosBox
    <li>Write the following commands:
        <ul>
            <li>masm clash
            <li>masm gun
            <li>masm rm
            <li>masm cmd_p1
            <li>masm cmd_p2
            <li>masm chat
            <li>masm start
            <li>masm level
            <li>masm powerups
            <li>masm win
            <li>link clash+rm+gun+cmd_p2+cmd_p1+chat+start+level+powerups+win
            <li>clash
        </ul>
</ul>
To run 2 players using serial port version:
<ul>
    <li>Open DosBox
    <li>Write the following commands:
        <ul>
            <li>masm clash</li>
            <li>masm gun</li>
            <li>masm rm</li>
            <li>masm cmd_p1</li>
            <li>masm cmd_p2</li>
            <li>masm chat1</li>
            <li>masm start</li>
            <li>masm level</li>
            <li>masm powerups</li>
            <li>masm win</li>
            <li>link clash+rm+gun+cmd_p2+cmd_p1+chat1+start+level+powerups+win</li>
            <li>clash</li>
        </ul>
</ul>
<h2>
    Versions
</h2>
<ul>
    <li><h5>2 Players on 1 PC</h5></li>
    The 2 players play on the same pc using the same keyboard.
    <li><h5>2 Players using serial port</h5></li>
    2 PCs are connected using the serial port cable, each player plays on his PC with complete synchronisation in instructions, in-game chat, gun fire and more!
</ul>
<h2>
    Limitations
</h2>
<ul>
    <li>This version is only optimized for MASM 6.11, any other version or assembler may not run correctly.</li>
    <li>In 2 Players using serial port version: name, initial points and level 2 are not synchronysed between the 2 PCs (yet).

</ul>
