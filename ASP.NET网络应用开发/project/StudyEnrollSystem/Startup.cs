using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Login04.Startup))]
namespace Login04
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
