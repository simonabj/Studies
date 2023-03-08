function [handle] = style_plot(fig, theme)
%STYLE_PLOT Summary of this function goes here
%   Detailed explanation goes here

if ~exist('fig', 'var')
    handle = gcf();
else
    handle = fig;
end

if ~exist('theme', 'var')
    theme='none';
end

if strcmp(theme, "none")
    ax_color = [0.1500 0.1500 0.1500];
    color = "none";
    fig_color = [0.94 0.94 0.94];
elseif strcmp(theme, "nord")
    ax_color = [0.847 0.871 0.914];
    color = "none";
    fig_color = "#2e3440";
end

set(handle, color=fig_color);

for idx = 1:numel(handle.Children)
    child = handle.Children(idx);
    
    if isa(child, 'matlab.graphics.illustration.ColorBar')
        set(child, 'Color', ax_color);
    elseif isa(child, 'matlab.graphics.layout.TiledChartLayout')
        set(child.XLabel, 'Color', ax_color)
        set(child.YLabel, 'Color', ax_color)
        for subchild_idx = 1:numel(child.Children)
                subchild = child.Children(subchild_idx);
            if isa(subchild, 'matlab.graphics.illustration.ColorBar')
                set(subchild, 'Color', ax_color); 
            elseif isa(subchild, 'matlab.graphics.illustration.Legend')
                set(subchild, 'TextColor', ax_color);
                set(subchild, 'Color', 'none');
            else
                display(class(subchild))
                set(subchild, 'Color', color);
                set(subchild.Title, 'Color', ax_color);
                set(subchild, 'XColor', ax_color);
                set(subchild, 'YColor', ax_color);
                set(subchild, 'ZColor', ax_color);
            end
        end
    elseif isa(child, 'matlab.graphics.illustration.Legend')
        set(child, 'TextColor', ax_color);
        set(child, 'Color', 'none');
    else
        if numel(child.YAxis) > 1
            for axis_idx = 1:numel(child.YAxis)
                subchild = child.YAxis(axis_idx);
                set(subchild, 'Color', ax_color);
            end
        end
        set(child, 'Color', color);
        set(child.Title, 'Color', ax_color);
        set(child, 'XColor', ax_color);
        set(child, 'YColor', ax_color);
        set(child, 'ZColor', ax_color);
    end
end

end

