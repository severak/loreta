<Cabbage> bounds(0, 0, 0, 0)
form caption("Loreta v 1") size(400, 300), guiMode("queue"), pluginId("lor1")
keyboard bounds(8, 202, 381, 88)
groupbox bounds(4, 8, 389, 60) channel("groupbox10001") text("Common")
label bounds(16, 38, 80, 16) channel("label10002") text("Modwheel")

combobox bounds(100, 36, 80, 20) channel("modwheel") text("vibrato", "morphing") value(1)
groupbox bounds(2, 70, 391, 82) channel("groupbox10004") text("Layer A")
label bounds(14, 98, 80, 16) channel("label10005") text("Timbre")
combobox bounds(98, 94, 80, 20) channel("a_timbre") text("piano", "el piano (SIN)", "e-bass", "e-organ (SAW)", "distorted", "guitar (SQR)", "organ", "oboe") value(1)
label bounds(182, 97, 80, 16) channel("label10007") text("transpose")
combobox bounds(267, 95, 117, 20) channel("a_transpose") text("no", "octave down", "octave up", "small detune", "more detune") value(1)
label bounds(15, 120, 80, 16) channel("label10009") text("Envelope")
combobox bounds(97, 119, 80, 20) channel("a_envelope") text("piano", "organ", "string", "flute", "slow-flute") value(1)
label bounds(181, 119, 80, 16) channel("label10011") text("filter")
combobox bounds(266, 117, 118, 20) channel("a_filter") value(1) text("none", "static 2k", "static 6k", "static 8k", "dynamic 8k", "dynamic 8k dry", "8k quack")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

giWaves[] init 9

giWaves[1] ftgen 0, 0, 0, 1, "akwf/AKWF_piano_0001.wav", 0, 0, 0
giWaves[2] ftgen 0, 0, 0, 1, "akwf/AKWF_epiano_0014.wav", 0, 0, 0
giWaves[3] ftgen 0, 0, 0, 1, "akwf/AKWF_ebass_0042.wav", 0, 0, 0
giWaves[4] ftgen 0, 0, 0, 1, "akwf/AKWF_eorgan_0033.wav", 0, 0, 0
giWaves[5] ftgen 0, 0, 0, 1, "akwf/AKWF_eguitar_0011.wav", 0, 0, 0
giWaves[6] ftgen 0, 0, 0, 1, "akwf/AKWF_eguitar_0003.wav", 0, 0, 0
giWaves[7] ftgen 0, 0, 0, 1, "akwf/AKWF_eorgan_0114.wav", 0, 0, 0
giWaves[8] ftgen 0, 0, 0, 1, "akwf/AKWF_oboe_0013.wav", 0, 0, 0

giTranspose[] init 6
giTranspose[1] = 1
giTranspose[2] = 0.5
giTranspose[3] = 2
giTranspose[4] = 1.05
giTranspose[5] = 1.1

;instrument will be triggered by keyboard widget
instr 1
    kbnd pchbend 0, 100
    kcps = p4 + kbnd
    kvel = p5

    ia_timbre chnget "a_timbre"
    ia_transpose chnget "a_transpose"
    ia_envelope chnget "a_envelope"
    ia_filter chnget "a_filter"
    
    
    aOutA poscil3 0.3, kcps * giTranspose[ia_transpose], giWaves[ia_timbre]
    
    if ia_envelope == 1 then
        ; piano-like
        kEnv madsr 0.05, 2, 0, 0.2
        kEnv = kEnv * kvel
    elseif ia_envelope == 2 then
        ; organ-like
        kEnv madsr 0.05, 0.01, 1, 0.05
    elseif ia_envelope == 3 then
        ; string-like
        kEnv madsr 0.05, 1, 0, 1
        kEnv = kEnv * kvel
    elseif ia_envelope == 4 then
        ; flute-like
        kEnv madsr 0.2, 0.1, 0.8, 0.4
    elseif ia_envelope == 5 then
        ; slow-flute-like
        kEnv madsr 0.5, 0.4, 0.6, 0.6    
    endif
    
    if ia_filter == 2 then
        aOutA moogladder aOutA, 2000, 0.5
    elseif ia_filter == 3 then
        aOutA moogladder aOutA, 6000, 0.5
    elseif ia_filter == 4 then
        aOutA moogladder aOutA, 8000, 0.5
    elseif ia_filter == 5 then
        aOutA moogladder aOutA, 8000*kEnv, 0.5
    elseif ia_filter == 6 then
        aOutA moogladder aOutA, 8000*kEnv, 0
    elseif ia_filter == 7 then
        aOutA moogladder aOutA, 8000*kEnv, 0.85            
    endif

    
    outs aOutA*kEnv, aOutA*kEnv
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
</CsScore>
</CsoundSynthesizer>
