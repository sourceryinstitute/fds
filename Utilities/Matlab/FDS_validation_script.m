% McGrattan
% March 21, 2011
% FDS_validation_script.m
%
% This script creates the plots that are included in the FDS Validation 
% Guide. It consists of calls to other scripts contained within the
% subfolder called "scripts". 
%
% The most important script is called dataplot. It reads the file called
% FDS_validation_dataplot_inputs.csv and generates 1000+ plots.
%
% Usage:
%
% >> FDS_validation_script([drange]);
%
% where drange is an optional argument.
%
% If you know the lines in the .csv file you want to process, set drange = [a:b],
% where a and b are the start and finish of the lines to be processed.  Note that
% drange is simply a list of array elements, so it is permissible to use, for example,
% [a:b,c].
%
% Alternatively, you can specify the "Dataname" for the case you want to plot:
%
% >> FDS_validation_script('WTC');
%
% In this case, all the WTC results will be plotted.
%
% Dataplot creates most of the plots for the Validation Guide.
% It must be run before scatplot, which makes the scatter plots.

function [] = FDS_validation_script(varargin)

close all
clearvars -except varargin

addpath 'scripts'

% Process variable argument list

run_subset=false;
run_dataplot=true;
if nargin>0
    run_subset=true;
end

% Miscellaneous other scripts for special cases

if ~run_subset % subset_if_1
    backward_facing_step
    beyler_hood
    sandia_helium_plume
    sandia_methane_fire
    spray_attenuation
    Cup_burner
    flame_height2
    purdue_flames
    christifire
    pressure_coefficient
    VTT_Sprays
    fm_datacenter_veltest
    umd_line_burner
else
    switch varargin{1}
        case {'backward_facing_step'};  backward_facing_step;  run_dataplot=false;
        case {'beyler_hood'}         ;  beyler_hood;           run_dataplot=false;
        case {'sandia_helium_plume'};   sandia_helium_plume;   run_dataplot=false;
        case {'sandia_methane_fire'};   sandia_methane_fire;   run_dataplot=false;
        case {'spray_attenuation'};     spray_attenuation;     run_dataplot=false;
        case {'Cup_burner'};            Cup_burner;            run_dataplot=false;
        case {'flame_height2'};         flame_height2;         run_dataplot=false;
        case {'purdue_flames'};         purdue_flames;         run_dataplot=false;
        case {'christifire'};           christifire;           run_dataplot=false;
        case {'pressure_coefficient'};  pressure_coefficient;  run_dataplot=false;
        case {'VTT_Sprays'};            VTT_Sprays;            run_dataplot=false;
        case {'fm_datacenter_veltest'}; fm_datacenter_veltest; run_dataplot=false;
        case {'umd_line_burner'};       umd_line_burner;       run_dataplot=false;
    end
end % subset_if_1

if run_dataplot % dataplot_if

    % Scripts that run prior to dataplot

    if ~run_subset % subset_if_2
        flame_height
        cat_mccaffrey
        NIST_RSE
        sippola_aerosol_deposition
        layer_height
        combine_csiro
        fm_datacenter_scatter
    else
        switch varargin{1}
            case {'Heskestad Flame Height'}
                flame_height
            case {'McCaffrey Plume'}
                cat_mccaffrey
            case {'NIST RSE 1994'}
                NIST_RSE
            case {'Sippola Aerosol Deposition'}
                sippola_aerosol_deposition
            case {'ATF Corridors','FM/SNL','NIST FSE 2008','NIST/NRC','NRCC Smoke Tower','PRISME','UL/NIST Vents','VTT','WTC'}
                layer_height
            case {'CSIRO Grassland Fires'}
                combine_csiro
            case {'FM Datacenter'}
                fm_datacenter_scatter
        end
    end % subset_if_2

    % Dataplot and scatplot options

    Dataplot_Inputs_File = [pwd,'/FDS_validation_dataplot_inputs.csv'];
    Working_Dir = [pwd, '/../../Validation/'];
    Manuals_Dir = [pwd, '/../../Manuals/'];
    Scatterplot_Inputs_File = [pwd, '/FDS_validation_scatterplot_inputs.csv'];

    % Statistics output options

    Stats_Output = 'Validation';
    Output_File = [pwd, '/FDS_validation_scatterplot_output.csv'];
    Statistics_Tex_Output = [pwd, '/../../Manuals/FDS_Validation_Guide/SCRIPT_FIGURES/ScatterPlots/validation_statistics.tex'];
    Histogram_Tex_Output = [pwd, '/../../Manuals/FDS_Validation_Guide/SCRIPT_FIGURES/ScatterPlots/validation_histograms.tex'];

    % Override the plot style options with NRC 1824 plot options

    NRC_Options = false;
    Append_To_Scatterplot_Title = '';

    % Run dataplot and scatplot scripts

    [saved_data,drange] = dataplot(Dataplot_Inputs_File, Working_Dir, Manuals_Dir, varargin);
    scatplot(saved_data, drange, ...
             'Manuals_Dir', Manuals_Dir, ...
             'Scatterplot_Inputs_File', Scatterplot_Inputs_File, ...
             'Stats_Output', Stats_Output, ...
             'Output_File', Output_File, ...
             'Statistics_Tex_Output', Statistics_Tex_Output, ...
             'Histogram_Tex_Output', Histogram_Tex_Output, ...
             'NRC_Options', NRC_Options, ...
             'Append_To_Scatterplot_Title', Append_To_Scatterplot_Title)

end  % dataplot_if

display('validation scripts completed successfully!')
