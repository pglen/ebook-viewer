#!/usr/bin/env python3

# Easy eBook Viewer by Michal Daniel

# Easy eBook Viewer is free software; you can redistribute it and/or modify it under the terms
# of the GNU General Public Licence as published by the Free Software Foundation.

# Easy eBook Viewer is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.  See the GNU General Public Licence for more details.

# You should have received a copy of the GNU General Public Licence along with
# Easy eBook Viewer; if not, write to the Free Software Foundation, Inc., 51 Franklin Street,
# Fifth Floor, Boston, MA 02110-1301, USA.

import gi

gi.require_version('Gtk', '3.0')
#gi.require_version('WebKit', '3.0')
#gi.require_version('WebKit2', '4.0')
#from gi.repository import WebKit
from gi.repository import WebKit2 as WebKit


class Viewer(WebKit.WebView):
    def __init__(self, window):
        """
        Provides Webkit WebView element to display ebook content
        :param window: Main application window reference, serves as communication hub
        """
        WebKit.WebView.__init__(self)

        # Allow transparency so we can use GTK theme as background
        # Can be overridden by CSS background property, needs to be rgba(0,0,0,0)
        #self.set_transparent(True)

        # Sets WebView settings for ebook display
        # No java script etc.
        #self.set_full_content_zoom(True)
        settings = self.get_settings()
        settings.set_enable_javascript(False)
        settings.set_enable_plugins ( False )
        settings.set_enable_page_cache ( False )
        #settings.set_enable_java_applet ( False )

        try:
            settings.set_enable_webgl ( False )
        except AttributeError:
            pass

        # Disable default menu: contains copy and reload options
        # Reload messes with custom styling, doesn't reload CSS
        # App is using own "copy" right click hack
        # It will allow in future to add more options on right click
        #settings.set_enable_default_context_menu ( False )

        settings.set_enable_html5_local_storage (False )

        self.connect('context-menu', self.callback)

        self.__window = window

    def load_current_chapter(self):
        """
        Loads current chapter as pointed by content porvider
        """
        file_url = self.__window.content_provider.get_chapter_file(self.__window.content_provider.current_chapter)
        # Using WebView.load_html_string since WebView.load_uri files for some html files
        # while load_html_string works just fine
        # It's a bug that needs to be resolved upstream

        try:
            with open(file_url) as file_open:
                self.load_html(file_open.read(), "file://" + file_url)
                print("Loaded: " + file_url)
        except IOError:
            print("Could not read: ", file_url)

    def set_style_day(self):
        """
        Sets style to day CSS
        """
        settings = self.get_settings()
        #settings.props.user_stylesheet_uri = "file:///usr/share/easy-ebook-viewer/css/day.css"
        # TODO: Prefix location of day.css so it can be set during install

    def set_style_night(self):
        """
        Sets style to night CSS
        """
        settings = self.get_settings()
        settings.props.user_stylesheet_uri = "file:///usr/share/easy-ebook-viewer/css/night.css"
        # TODO: Prefix location of night.css so it can be set during install

    def callback(self, webview, context_menu, hit_result_event, event):
        self.__window.show_menu()
