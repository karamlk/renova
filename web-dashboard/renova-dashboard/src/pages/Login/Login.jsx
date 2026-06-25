import "./Login.css";
import { useState } from "react";
import { loginRequest } from "../../api/auth";
import { useNavigate } from "react-router-dom";
import Errordialog from "../../components/Errordialog/Errordialog";
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import VisibilityIcon from '@mui/icons-material/Visibility';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
import WestIcon from '@mui/icons-material/West';
export default function Login() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  const [showError, setShowError] = useState(false);
    async function handleLogin(e){
    e.preventDefault();
    try{
          let response = await loginRequest(email, password);
          if(response.status >= 200 && response.status < 300 && response.data.token && response.data.role==='admin'){
            localStorage.setItem('token', response.data.token);
            localStorage.setItem('role', response.data.role);
            navigate('/dashboard', { replace: true });

          }

    }catch(error){
      setErrorMessage(error.response.data.message);
      setShowError(true);
    }
  } 
       return (
    <div className="login-page">
      {showError && (<Errordialog message={errorMessage} onClose={() => setShowError(false)}/>)}
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

          <form onSubmit={handleLogin}>
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
                <span className="show-pass" onClick={() => {setShowPassword(!showPassword)}}>
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