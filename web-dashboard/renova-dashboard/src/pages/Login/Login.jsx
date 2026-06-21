import "./Login.css";
import { useState } from "react";
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import VisibilityIcon from '@mui/icons-material/Visibility';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
import WestIcon from '@mui/icons-material/West';
export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  

  const handleSubmit = (e) => {
    e.preventDefault();
    // هنا ستضيف منطق تسجيل الدخول لاحقاً
    console.log('Email:', email);
    console.log('Password:', password);
   
    
    // مثال: توجيه إلى لوحة التحكم
    // window.location.href = '/dashboard';
  };

  const PasswordVisibility = () => {
    setShowPassword(!showPassword);
  };
       return (
    <div className="login-page">
      <div className="login-container">
        <div className="info-side">
          <div className="brand">
            <img src="/assets/images/logo.png" alt="Logo" width="95" height="95" />
            <div> 
            <h2>ري<span>ن</span>وفا</h2>
            <p>نظام إعادة الإعمار الذكي</p>
            </div>
          </div>
          <div className="info-text">
            <h3>مرحباً بعودتك</h3>
            <p>قم بتسجيل الدخول لإدارة مشاريع إعادة الإعمار بكفاءة.</p>
            <div className="features">
              <span><CheckCircleIcon sx={{ color: '#f07c1f' }}/> إدارة المشاريع</span>
              <span><CheckCircleIcon sx={{ color: '#f07c1f' }}/>  متابعة التقدم</span>
              <span><CheckCircleIcon sx={{ color: '#f07c1f' }}/>  تقارير فورية</span>
            </div>
          </div>
          <div className="footer-text">© 2024 Renova</div>
        </div>

        <div className="form-side">
          <h3>تسجيل الدخول <span>إلى حسابك</span></h3>
          <p className="sub">أدخل بياناتك للوصول إلى لوحة التحكم</p>

          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label htmlFor="email">البريد الإلكتروني</label>
              <input
                type="email"
                id="email"
                placeholder="admin@renova.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>

            <div className="form-group">
              <label htmlFor="password">كلمة المرور</label>
              <div className="pass-lab">
                <input
                  type={showPassword ? 'text' : 'password'}
                  id="password"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                />
                <span className="show-pass" onClick={PasswordVisibility}>
                  {showPassword ? (
                    <VisibilityOffIcon sx={{ color: 'rgba(255, 255, 255, 0.6)' }} />
                  ) : (
                    <VisibilityIcon sx={{ color: 'rgba(255, 255, 255, 0.6)' }} />
                  )}
                </span>
              </div>
            </div>
            <button type="submit" className="btn-submit">
               تسجيل الدخول<WestIcon sx={{ color: 'white' }} />
            </button>
          </form>
        </div>
      </div>
    </div>
  );
   
}