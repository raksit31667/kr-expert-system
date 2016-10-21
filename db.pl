go :- hypothesize(Computer),
       write('I guess that you should: '),
       write(Computer), nl, undo.

 /* hypotheses to be tested */
hypothesize(check_monitor_power_source) :- check_monitor_power_source, !.
hypothesize(check_both_ends_of_video_cable) :- check_both_ends_of_video_cable, !.
hypothesize(replace_or_repair_cable_connector) :- replace_or_repair_cable_connector, !.
hypothesize(reseat_ram_and_video_adapter) :- reseat_ram_and_video_adapter, !.
hypothesize(load_default_from_bios) :- load_default_from_bios, !.
hypothesize(remove_motherboard_battery_for_1_hour) :- remove_motherboard_battery_for_1_hour, !.
hypothesize(check_fan_power_point) :- check_fan_power_point, !.
hypothesize(swap_ram_swap_video) :- swap_ram_swap_video, !.
hypothesize(restore_adapter) :- restore_adapter, !.
hypothesize(check_motherboard_performance) :- check_motherboard_performance, !.
hypothesize(try_different_power_supply) :- try_different_power_supply, !.
hypothesize(backup_the_data_on_the_drive) :- backup_the_data_on_the_drive, !.
hypothesize(check_cd_or_dvd_drive) :- check_cd_or_dvd_drive, !.
hypothesize(check_cmos_settings) :- check_cmos_settings, !.
hypothesize(require_cleaning) :- require_cleaning, !.
hypothesize(connect_to_known_good_outlet). /* no diagnosis */

/* computer identification rules */
check_monitor_power_source :- power_comes_on, video_failure, verify(monitor_led_off).
check_both_ends_of_video_cable :- power_comes_on, video_failure, verify(hear_string_of_beeps), verify(video_cable_insecure).
replace_or_repair_cable_connector :- power_comes_on, video_failure, verify(hear_string_of_beeps).
reseat_ram_and_video_adapter :- power_comes_on, video_failure.
load_default_from_bios :- power_comes_on, motherboard_failure, verify(freeze_on_boot), verify(freeze_barbones), verify(can_access_bios).
remove_motherboard_battery_for_1_hour :- power_comes_on, motherboard_failure, verify(freeze_on_boot), verify(freeze_barbones), verify(bios_settings_change).
check_fan_power_point :- power_comes_on, motherboard_failure, verify(freeze_on_boot), verify(freeze_barbones), verify(fan_not_active).
swap_ram_swap_video :- power_comes_on, motherboard_failure, verify(freeze_on_boot), verify(freeze_barbones).
restore_adapter :- power_comes_on, motherboard_failure, verify(freeze_on_boot).
check_motherboard_performance :- power_comes_on, motherboard_failure.
try_different_power_supply :- power_comes_on, verify(need_two_tries_to_boot).
backup_the_data_on_the_drive :- power_comes_on, hard_drive_failure, verify(bios_register_drive), verify(smart_error).
check_cd_or_dvd_drive :- power_comes_on, hard_drive_failure, verify(bios_register_drive).
check_cmos_settings :- power_comes_on, hard_drive_failure.
require_cleaning :- power_comes_on.

/* classification rules */
power_comes_on :- verify(power_comes_on).
video_failure :- verify(no_live_screen), !.
motherboard_failure :- verify(hear_more_than_1_beep), !.
hard_drive_failure :- verify(no_loud_fan_noise).

/* how to ask questions */
ask(Question) :-
        write('Does the computer have the following problem: '),
        write(Question), write('? (y/n)'),
         read(Response), nl,
         ( (Response == yes ; Response == y)
         -> assert(yes(Question)) ;
         assert(no(Question)), fail).
:- dynamic yes/1,no/1.

/* How to verify something */
verify(S) :- (yes(S) -> true ; (no(S) -> fail ; ask(S))).

/* undo all yes/no assertions */
undo :- retract(yes(_)),fail.
undo :- retract(no(_)),fail.
undo.
